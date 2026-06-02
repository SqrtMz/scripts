#! /usr/bin/env bash

waybar &
nm-applet &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
otd-daemon &
hyprpaper &
hyprpm reload -n &