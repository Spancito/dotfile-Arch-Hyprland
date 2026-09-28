#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
gi.require_version('Playerctl', '2.0')
from gi.repository import Gtk, Gdk, GLib, Playerctl, GdkPixbuf, GtkLayerShell
import urllib.request
import os
import sys

LOCK_FILE = "/tmp/waybar_miniplayer.lock"

if os.path.exists(LOCK_FILE):
    os.remove(LOCK_FILE)
    sys.exit(0)
else:
    with open(LOCK_FILE, 'w') as f:
        f.write("running")

class MiniPlayer(Gtk.Window):
    def __init__(self):
        super().__init__(title="Mini Player")
        self.set_name("miniplayer")
        self.set_default_size(380, 150)

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_namespace(self, "miniplayer")
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.TOP)
        
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, 4)
        
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.BOTTOM, False)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.LEFT, False)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, False)
        
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.EXCLUSIVE)

        self.player = Playerctl.Player()
        self.player.connect("playback-status", self.on_status_change)
        self.player.connect("metadata", self.on_metadata_change)

        css_provider = Gtk.CssProvider()
        css_path = os.path.expanduser("~/.config/waybar/miniplayer.css")
        if os.path.exists(css_path):
            css_provider.load_from_path(css_path)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), 
            css_provider, 
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        self.box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.box.set_name("main-box")
        self.box.set_border_width(16)
        self.add(self.box)

        content_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=20)
        self.box.pack_start(content_box, True, True, 0)

        self.image_stack = Gtk.Stack()
        self.image_stack.set_size_request(100, 100)
        self.image_stack.set_halign(Gtk.Align.CENTER)
        content_box.pack_start(self.image_stack, False, False, 0)

        self.image = Gtk.Image()
        self.image.set_name("cover")
        self.image.set_size_request(100, 100)
        self.image_stack.add_named(self.image, "cover")

        self.icon_label = Gtk.Label()
        self.icon_label.set_name("app-icon")
        self.icon_label.set_markup("<span>󰎆</span>")
        self.icon_label.set_valign(Gtk.Align.CENTER)
        self.icon_label.set_halign(Gtk.Align.CENTER)
        self.image_stack.add_named(self.icon_label, "icon")

        right_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        right_box.set_valign(Gtk.Align.CENTER)
        content_box.pack_start(right_box, True, True, 0)

        self.title_label = Gtk.Label()
        self.title_label.set_name("title")
        self.title_label.set_halign(Gtk.Align.START)
        self.title_label.set_line_wrap(True)
        self.title_label.set_max_width_chars(25)
        self.title_label.set_ellipsize(3)
        self.title_label.set_markup("<b>No Media</b>")
        right_box.pack_start(self.title_label, False, False, 0)

        self.artist_label = Gtk.Label()
        self.artist_label.set_name("artist")
        self.artist_label.set_halign(Gtk.Align.START)
        self.artist_label.set_line_wrap(True)
        self.artist_label.set_max_width_chars(25)
        self.artist_label.set_ellipsize(3)
        right_box.pack_start(self.artist_label, False, False, 0)

        ctrl_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=15)
        ctrl_box.set_halign(Gtk.Align.START)
        right_box.pack_start(ctrl_box, False, False, 5)

        prev_btn = Gtk.Button(label="󰒮")
        prev_btn.connect("clicked", lambda x: self.player.previous())
        ctrl_box.pack_start(prev_btn, False, False, 0)

        self.play_btn = Gtk.Button(label="󰐊")
        self.play_btn.connect("clicked", self.toggle_play)
        ctrl_box.pack_start(self.play_btn, False, False, 0)

        next_btn = Gtk.Button(label="󰒭")
        next_btn.connect("clicked", lambda x: self.player.next())
        ctrl_box.pack_start(next_btn, False, False, 0)

        self.progress = Gtk.ProgressBar()
        self.progress.set_name("progress")
        self.box.pack_start(self.progress, False, False, 0)

        try:
            if self.player.get_title():
                self.on_metadata_change(self.player, self.player.props.metadata)
                self.on_status_change(self.player, self.player.props.playback_status)
        except Exception as e:
            pass

        GLib.timeout_add(1000, self.update_progress)
        self.can_close = False
        GLib.timeout_add(300, self.enable_close)
        self.connect("focus-out-event", self.on_focus_out)
        self.connect("key-press-event", self.on_key_press)
        self.show_all()

    def toggle_play(self, btn):
        try:
            self.player.play_pause()
            if self.play_btn.get_label() == "󰐊":
                self.play_btn.set_label("󰏤")
            else:
                self.play_btn.set_label("󰐊")
        except:
            pass

    def enable_close(self):
        self.can_close = True
        return False

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.quit()

    def on_focus_out(self, widget, event):
        if self.can_close:
            self.quit()

    def quit(self):
        if os.path.exists(LOCK_FILE):
            os.remove(LOCK_FILE)
        Gtk.main_quit()

    def update_progress(self):
        try:
            metadata_var = self.player.props.metadata
            if metadata_var:
                metadata = metadata_var.unpack()
                length = metadata.get("mpris:length", 0)
                if length > 0 and length < 9000000000000000000:
                    pos = self.player.get_position()
                    self.progress.set_fraction(pos / length)
                else:
                    self.progress.set_fraction(0)
            else:
                self.progress.set_fraction(0)
        except Exception as e:
            self.progress.set_fraction(0)
        return True

    def on_status_change(self, player, status):
        try:
            if status == Playerctl.PlaybackStatus.PLAYING:
                self.play_btn.set_label("󰏤")
            else:
                self.play_btn.set_label("󰐊")
        except:
            pass

    def on_metadata_change(self, player, metadata_var):
        try:
            title = player.get_title() or "Unknown"
            artist = player.get_artist() or "Unknown"
            self.title_label.set_markup(f"<b>{title}</b>")
            self.artist_label.set_text(artist)
    
            if metadata_var:
                metadata = metadata_var.unpack()
            else:
                metadata = {}
    
            art_url = metadata.get("mpris:artUrl")
            has_art = False
            if art_url:
                if art_url.startswith("file://"):
                    path = art_url[7:]
                else:
                    try:
                        path = "/tmp/miniplayer_art.png"
                        req = urllib.request.Request(
                            art_url, 
                            data=None, 
                            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
                        )
                        with urllib.request.urlopen(req) as response, open(path, 'wb') as out_file:
                            out_file.write(response.read())
                    except Exception as e:
                        path = None
                if path and os.path.exists(path):
                    try:
                        pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(path, 100, 100, True)
                        self.image.set_from_pixbuf(pixbuf)
                        has_art = True
                    except:
                        pass
    
            if has_art:
                self.image_stack.set_visible_child_name("cover")
            else:
                pname = getattr(player.props, 'player_name', '')
                player_name = pname.lower() if pname else ""
                icons = {
                    "spotify": "",
                    "zuno": "",
                    "brave": "",
                    "chromium": "",
                    "firefox": "",
                    "vlc": "󰕼",
                    "mpv": ""
                }
                icon = "󰎆"
                for k, v in icons.items():
                    if k in player_name:
                        icon = v
                        break
                self.icon_label.set_markup(f"<span>{icon}</span>")
                self.image_stack.set_visible_child_name("icon")
        except Exception as e:
            pass

try:
    win = MiniPlayer()
    win.connect("destroy", win.quit)
    Gtk.main()
except Exception as e:
    if os.path.exists(LOCK_FILE):
        os.remove(LOCK_FILE)
