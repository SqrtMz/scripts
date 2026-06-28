#! /usr/bin/env bash

waybar &
nm-applet &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
otd-daemon &
hyprpaper &
/usr/lib/hyprpolkitagent/hyprpolkitagent &
/usr/lib/xdg-desktop-portal &