#!/usr/bin/env python3
import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib
from gi.repository.Playerctl import Player
import argparse
import logging
import sys
import signal
import json
import os
import threading
import subprocess
from typing import List

logger = logging.getLogger(__name__)

current_cava = "      "
current_track_info = ""
current_player_class = "custom-none"
current_player_alt = "none"
output_lock = threading.Lock()
cava_process = None

def signal_handler(sig, frame):
    global cava_process
    if cava_process:
        try:
            cava_process.terminate()
        except:
            pass
    sys.exit(0)

def print_combined_output():
    with output_lock:
        if current_track_info:
            text = f"<span face='monospace'>{current_cava}</span> {current_track_info}"
            output = {
                "text": text,
                "class": current_player_class,
                "alt": current_player_alt
            }
            sys.stdout.write(json.dumps(output) + "\n")
            sys.stdout.flush()
        else:
            sys.stdout.write("\n")
            sys.stdout.flush()

def cava_thread_func():
    global current_cava
    global cava_process
    dict_chars = " ▂▃▄▅▆▇█"
    try:
        cava_process = subprocess.Popen(['cava', '-p', os.path.expanduser('~/.config/cava/config_waybar')], stdout=subprocess.PIPE, text=True)
        while True:
            line = cava_process.stdout.readline()
            if not line:
                break
            res = ""
            for char in line.strip():
                if char.isdigit():
                    idx = int(char)
                    if 0 <= idx <= 7:
                        res += dict_chars[idx]
            
            res = res.ljust(6, ' ')
            if len(res) > 6:
                res = res[:6]
            
            with output_lock:
                current_cava = res
            
            GLib.idle_add(print_combined_output)
    except Exception as e:
        pass

class PlayerManager:
    def __init__(self, selected_player=None, excluded_player=[]):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()
        self.manager.connect("name-appeared", lambda *args: self.on_player_appeared(*args))
        self.manager.connect("player-vanished", lambda *args: self.on_player_vanished(*args))

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)
        self.selected_player = selected_player
        self.excluded_player = excluded_player.split(',') if excluded_player else []

        self.init_players()

    def init_players(self):
        for player in self.manager.props.player_names:
            if player.name in self.excluded_player:
                continue
            if self.selected_player is not None and self.selected_player != player.name:
                continue
            self.init_player(player)

    def run(self):
        t = threading.Thread(target=cava_thread_func, daemon=True)
        t.start()
        
        self.loop.run()

    def init_player(self, player):
        player = Playerctl.Player.new_from_name(player)
        player.connect("playback-status", self.on_playback_status_changed, None)
        player.connect("metadata", self.on_metadata_changed, None)
        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def get_players(self) -> List[Player]:
        return self.manager.props.players

    def on_playback_status_changed(self, player, status, _=None):
        self.on_metadata_changed(player, player.props.metadata)

    def get_first_playing_player(self):
        players = self.get_players()
        if len(players) > 0:
            for player in players[::-1]:
                if player.props.status == "Playing":
                    return player
            return players[0]
        else:
            return None

    def show_most_important_player(self):
        current_player = self.get_first_playing_player()
        if current_player is not None:
            self.on_metadata_changed(current_player, current_player.props.metadata)
        else:    
            global current_track_info
            with output_lock:
                current_track_info = ""
            GLib.idle_add(print_combined_output)

    def on_metadata_changed(self, player, metadata, _=None):
        global current_track_info, current_player_class, current_player_alt
        player_name = player.props.player_name
        artist = player.get_artist()
        if artist: artist = artist.replace("&", "&amp;")
        title = player.get_title()
        if title: title = title.replace("&", "&amp;")

        track_info = ""
        metadata_dict = {}
        if metadata:
            metadata_dict = metadata.unpack()
            
        if player_name == "spotify" and "mpris:trackid" in metadata_dict and ":ad:" in metadata_dict["mpris:trackid"]:
            track_info = "Advertisement"
        elif artist and title:
            track_info = f"{artist} - {title}"
        elif title:
            track_info = title


        current_playing = self.get_first_playing_player()
        if current_playing is None or current_playing.props.player_name == player.props.player_name:
            with output_lock:
                current_track_info = track_info
                current_player_class = "custom-" + player_name
                current_player_alt = player_name
            GLib.idle_add(print_combined_output)

    def on_player_appeared(self, _, player):
        if player.name in self.excluded_player:
            return
        if player is not None and (self.selected_player is None or player.name == self.selected_player):
            self.init_player(player)

    def on_player_vanished(self, _, player):
        self.show_most_important_player()

def main():
    player = PlayerManager(None, None)
    player.run()

if __name__ == "__main__":
    main()
