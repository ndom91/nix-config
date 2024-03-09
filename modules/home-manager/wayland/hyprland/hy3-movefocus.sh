#!/usr/bin/env bash
# Move focus script to workaround hy3 not supporting movefocus
# across multiple monitors
# Use: bind = $mainMod, L, exec, movefocus.sh l
#      bind = $mainMod, R, exec, movefocus.sh r
# see: https://github.com/outfoxxed/hy3/issues/2

NowWindow="$(hyprctl activewindow -j | jq ".address")"

hyprctl dispatch hy3:movefocus "$1" # && sleep 0.05
ThenWindow="$(hyprctl activewindow -j | jq ".address")"
if [ "$NowWindow" == "$ThenWindow" ]; then
  hyprctl dispatch movefocus "$1"
fi
