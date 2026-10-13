#!/usr/bin/env python3
import os
import sys
import json
import signal
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
from gi.repository import Gtk, Gdk, GLib, GtkLayerShell

LOCK_FILE = '/tmp/waybar_taskswidget.pid'
try:
    if os.path.exists(LOCK_FILE):
        with open(LOCK_FILE, 'r') as f:
            old_pid = int(f.read().strip())
        try:
            os.kill(old_pid, signal.SIGTERM)
        except OSError:
            pass
except Exception:
    pass

with open(LOCK_FILE, 'w') as f:
    f.write(str(os.getpid()))

DATA_FILE = os.path.expanduser('~/.config/tareas.json')

def load_tasks():
    if not os.path.exists(DATA_FILE):
        return []
    try:
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            data = json.load(f)
            if isinstance(data, list):
                return data
            return []
    except Exception:
        return []

def save_tasks(tasks):
    try:
        with open(DATA_FILE, 'w', encoding='utf-8') as f:
            json.dump(tasks, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

class TasksWidget(Gtk.Window):
    def __init__(self):
        super().__init__(title="Tasks Widget")
        self.set_name("taskswidget")
        self.set_default_size(360, 420)

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_namespace(self, "taskswidget")
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.TOP)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, 4)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.LEFT, 15)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.LEFT, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, False)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.BOTTOM, False)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.EXCLUSIVE)

        css_provider = Gtk.CssProvider()
        css_path = os.path.expanduser("~/.config/waybar/miniplayer.css")
        if os.path.exists(css_path):
            css_provider.load_from_path(css_path)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.editing_idx = None
        self.active_entry_t = None
        self.active_entry_d = None

        self.main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.main_box.set_name("tasks-main-box")
        self.add(self.main_box)

        search_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        self.main_box.pack_start(search_box, False, False, 0)

        self.entry = Gtk.Entry()
        self.entry.set_name("task-search-entry")
        self.entry.set_placeholder_text("Escribe una tarea...")
        self.entry.connect("activate", self.on_add_task)
        search_box.pack_start(self.entry, True, True, 0)

        add_btn = Gtk.Button(label="+")
        add_btn.set_name("task-add-btn")
        add_btn.connect("clicked", self.on_add_task)
        search_box.pack_start(add_btn, False, False, 0)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled.set_min_content_height(320)
        self.main_box.pack_start(scrolled, True, True, 0)

        self.list_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.list_box.set_name("tasks-list")
        scrolled.add(self.list_box)

        self.tasks = load_tasks()
        self.render_tasks()

        self.can_close = False
        GLib.timeout_add(300, self.enable_close)
        self.connect("focus-out-event", self.on_focus_out)
        self.connect("key-press-event", self.on_key_press)
        self.show_all()

    def enable_close(self):
        self.can_close = True
        return False

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            if self.editing_idx is not None:
                self.save_current_editing()
            else:
                self.quit()

    def on_focus_out(self, widget, event):
        if self.can_close:
            if self.editing_idx is not None:
                self.save_current_editing(rerender=False)
            self.quit()

    def quit(self):
        if os.path.exists(LOCK_FILE):
            os.remove(LOCK_FILE)
        Gtk.main_quit()

    def save_current_editing(self, rerender=True):
        if self.editing_idx is not None and 0 <= self.editing_idx < len(self.tasks):
            if self.active_entry_t and self.active_entry_d:
                new_t = self.active_entry_t.get_text().strip()
                new_d = self.active_entry_d.get_text().strip()
                if new_t:
                    self.tasks[self.editing_idx]["titulo"] = new_t
                    self.tasks[self.editing_idx]["detalles"] = new_d
                    save_tasks(self.tasks)
        self.editing_idx = None
        self.active_entry_t = None
        self.active_entry_d = None
        if rerender:
            self.render_tasks()

    def render_tasks(self):
        for child in self.list_box.get_children():
            self.list_box.remove(child)

        if not self.tasks:
            empty_lbl = Gtk.Label(label="No hay tareas pendientes")
            empty_lbl.get_style_context().add_class("task-desc")
            empty_lbl.set_margin_top(20)
            self.list_box.pack_start(empty_lbl, False, False, 0)
            self.list_box.show_all()
            return

        for idx, task in enumerate(self.tasks):
            if self.editing_idx == idx:
                edit_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
                edit_box.get_style_context().add_class("task-edit-box")

                entry_t = Gtk.Entry()
                entry_t.get_style_context().add_class("task-edit-entry")
                entry_t.set_text(task.get("titulo", ""))
                entry_t.set_placeholder_text("Título...")
                edit_box.pack_start(entry_t, False, False, 0)

                entry_d = Gtk.Entry()
                entry_d.get_style_context().add_class("task-edit-entry")
                entry_d.set_text(task.get("detalles", ""))
                entry_d.set_placeholder_text("Detalles adicionales...")
                edit_box.pack_start(entry_d, False, False, 0)

                self.active_entry_t = entry_t
                self.active_entry_d = entry_d

                entry_t.connect("activate", lambda w: self.save_current_editing())
                entry_d.connect("activate", lambda w: self.save_current_editing())

                self.list_box.pack_start(edit_box, False, False, 0)
            else:
                row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
                row.get_style_context().add_class("task-row")

                btn_event = Gtk.EventBox()
                btn_event.set_visible_window(False)
                btn_event.connect("button-press-event", self.make_edit_trigger_handler(idx))

                info_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
                title_lbl = Gtk.Label()
                title_lbl.get_style_context().add_class("task-title")
                title_lbl.set_markup(f"<b>{GLib.markup_escape_text(task.get('titulo', ''))}</b>")
                title_lbl.set_halign(Gtk.Align.START)
                title_lbl.set_line_wrap(True)
                info_box.pack_start(title_lbl, False, False, 0)

                det = task.get("detalles", "").strip()
                if det:
                    desc_lbl = Gtk.Label()
                    desc_lbl.get_style_context().add_class("task-desc")
                    desc_lbl.set_text(det)
                    desc_lbl.set_halign(Gtk.Align.START)
                    desc_lbl.set_line_wrap(True)
                    info_box.pack_start(desc_lbl, False, False, 0)

                btn_event.add(info_box)
                row.pack_start(btn_event, True, True, 0)

                del_btn = Gtk.Button(label="✕")
                del_btn.get_style_context().add_class("task-delete-btn")
                del_btn.connect("clicked", self.make_delete_handler(idx))
                row.pack_start(del_btn, False, False, 0)

                self.list_box.pack_start(row, False, False, 0)

        self.list_box.show_all()

    def on_add_task(self, widget):
        txt = self.entry.get_text().strip()
        if not txt:
            return
        self.tasks.insert(0, {"titulo": txt, "detalles": ""})
        save_tasks(self.tasks)
        self.entry.set_text("")
        self.render_tasks()

    def make_delete_handler(self, idx):
        def handler(btn):
            if 0 <= idx < len(self.tasks):
                self.tasks.pop(idx)
                save_tasks(self.tasks)
                if self.editing_idx == idx:
                    self.editing_idx = None
                    self.active_entry_t = None
                    self.active_entry_d = None
                elif self.editing_idx is not None and self.editing_idx > idx:
                    self.editing_idx -= 1
                self.render_tasks()
        return handler

    def make_edit_trigger_handler(self, idx):
        def handler(widget, event):
            if self.editing_idx is not None:
                self.save_current_editing(rerender=False)
            self.editing_idx = idx
            self.render_tasks()
            if self.active_entry_t:
                self.active_entry_t.grab_focus()
        return handler

try:
    win = TasksWidget()
    win.connect("destroy", win.quit)
    Gtk.main()
except Exception:
    if os.path.exists(LOCK_FILE):
        os.remove(LOCK_FILE)
