#! /usr/bin/env bash

ln -sf ${HOME}/mz-dotfiles/modules/alacritty 					${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/fastfetch 					${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/flameshot 					${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/hypr 						${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/kitty 						${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/luciole 						${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/mimeapps.list 				${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/nix 							${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/nvim 						${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/rofi 						${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/sway 						${HOME}/.config/
ln -sf ${HOME}/mz-dotfiles/modules/xdg-desktop-portal 			${HOME}/.config/

ln -sf ${HOME}/mz-dotfiles/modules/zsh 				${HOME}/.config/
echo "source ${HOME}/.config/zsh/.zshenv" > ${HOME}/.zshenv