#! /usr/bin/env bash

sudo timedatectl set-ntp true

clear

echo "Mz's graphic's installer"
echo -e "This script works once connected to internet \n"

sudo pacman -S pipewire pipewire-audio gst-plugin-pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-roc realtime-privileges xorg dolphin kitty firefox ark ntfs-3g btop nvtop cmake gthumb zsh ncdu sshfs obs-studio arch-install-scripts --noconfirm --needed

paru --version

if (( $? != 0 ))
then
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
fi

while true
do
    echo
    echo "Install AMDGPU drivers? [y/n]"
    read tAMD

    echo

    case $tAMD in
        [Yy]* ) echo "Installing AMDGPU drivers"
                sudo pacman -S xf86-video-amdgpu lib32-vulkan-radeon vulkan-tools lib32-libva-mesa-driver vdpauinfo clinfo --noconfirm --needed
                break;;
        
        [Nn]* ) echo "AMDGPU drivers won't be installed"
                break;;

        * ) echo "Invalid option, try again"
            continue;;
    esac
done

while true
do
    echo
    echo "Install Intel drivers? [y/n]"
    read tIntel

    echo

    case $tIntel in
        [Yy]* ) echo "Installing Intel drivers"
                sudo pacman -S xf86-video-intel lib32-vulkan-intel vulkan-tools lib32-mesa intel-media-driver libva-utils libva-intel-driver intel-compute-runtime vdpauinfo clinfo --noconfirm --needed
                break;;
        
        [Nn]* ) echo "Intel drivers won't be installed"
                break;;

        * ) echo "Invalid option, try again"
            continue;;
    esac
done

while true
do
    echo
    echo "Install NVIDIA drivers? [y/n]"
    read tNV

    echo

    case $tNV in
        [Yy]* ) echo "Installing AMDGPU drivers"
                sudo pacman -S xf86-video-nouveau --noconfirm --needed
                break;;
        
        [Nn]* ) echo "NVIDIA drivers won't be installed"
                break;;

        * ) echo "Invalid option, try again"
            continue;;
    esac
done

while true
do
    echo
    echo "Select a desktop"
    echo "1. HyprlandWM"
    echo "2. SwayWM"
    echo "3. KDE Plasma"
    read dSel

    echo

    case $dSel in
        1 ) echo "HyprlandWM Selected"
            desktop="hyprland"
            sudo pacman -S hyprland brightnessctl pavucontrol waybar rofi cliphist ttf-nerd-fonts-symbols  ttf-font-awesome breeze breeze-gtk gnome-keyring wev nwg-look qt6ct grim slurp xdg-desktop-portal-hyprland archlinux-xdg-menu polkit-gnome hyprpaper network-manager-applet kvantum --noconfirm --needed

            if [ ! -e "/etc/xdg/menus/applications.menu" ]
            then
                sudo ln -s /etc/xdg/menus/arch-applications.menu /etc/xdg/menus/applications.menu
            fi
            break;;
        
        2 ) echo "SwayWM Selected"
            desktop="sway"
            sudo pacman -S sway swaybg brightnessctl pavucontrol waybar rofi cliphist  ttf-nerd-fonts-symbols ttf-font-awesome breeze breeze-gtk gnome-keyring wev nwg-look qt6ct grim slurp xdg-desktop-portal xdg-desktop-portal-wlr archlinux-xdg-menu polkit-gnome network-manager-applet kvantum --noconfirm --needed

            if [ ! -e "/etc/xdg/menus/applications.menu" ]
            then
                sudo ln -s /etc/xdg/menus/arch-applications.menu /etc/xdg/menus/applications.menu
            fi
            break;;

        3 ) echo "KDE Plasma Selected"
            desktop="plasma"
            sudo pacman -S plasma
            break;;

        * ) echo "Invalid option, try again"
            continue;;
    esac
done

sudo systemctl enable sddm

while true
do
    echo
    echo -e "Install Nix and Home manager? [y/n] \n"
    read tNix

    echo

    case $tNix in
        [Yy]* ) echo -e "Installing... \n"
                curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sudo sh -s -- --daemon
                /nix/var/nix/profiles/default/bin/nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
                /nix/var/nix/profiles/default/bin/nix-channel --update
                /nix/var/nix/profiles/default/bin/nix-shell '<home-manager>' -A install
                break;;
        
        [Nn]* ) echo "Nix and Home manager won't be installed \n"
                break;;

        * ) echo "Invalid option, try again"
            continue;;
    esac
done

echo
echo "Process Complete"