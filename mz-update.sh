#! /usr/bin/env bash

cd ~/mz-dotfiles &&
pacman -Qqe > pacman-packages.txt &&
paru -Syu --noconfirm &&
nix flake update &&
home-manager switch --flake .#mz &&
cd
