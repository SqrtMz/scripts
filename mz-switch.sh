#! /usr/bin/env bash

cd ~/mz-dotfiles &&
pacman -Qqe > pacman-packages.txt &&
home-manager switch --flake .#mz &&
cd