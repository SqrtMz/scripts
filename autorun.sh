#! /usr/bin/env bash

waybar &
nm-applet &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
otd-daemon &
/home/mz/Desktop/waywallen-0.4.3-x86_64.AppImage --no-ui &
/usr/lib/hyprpolkitagent/hyprpolkitagent &
/usr/lib/xdg-desktop-portal &