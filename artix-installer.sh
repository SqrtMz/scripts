#! /usr/bin/env bash

function fatal_error() {
    if (( $1 != 0 ))
    then
        echo
        echo -e "There was an error while $2. Killing the script... \n"
        exit $1
    fi
}

# Time and date sync
timedatectl set-ntp true

# To avoid dead keys errors at install time
pacman -Sy
pacman -S archlinux-keyring --noconfirm --needed

clear

echo "   ____         __  __  ___  "
echo "  / __/__  ____/ /_/  |/  /__"
echo " _\ \/ _ \/ __/ __/ /|_/ /_ /"
echo "/___/\_, /_/  \__/_/  /_//__/"
echo "      /_/                    "

echo "This installer works once connected to internet and the partition table has been created"
echo

# User Configurations
echo -e "Hostname: \c"
read hostname

echo -e "User: \c"
read user

echo -e "Root user password: \c"
read root_password

echo -e "User password: \c"
read user_password

echo -e "Timezone (if don't know, stop the script and use "timedatectl list-timezones") [Continent/City]: \c"
read timezone

ls /sys/firmware/efi/efivars &> /dev/null

if (( $? != 0 ))
then
    echo -e "EFI system not detected, BIOS bootloader installation will be used \n"
    echo -e "Grub will be used as bootloader"
    bootmode="BIOS"
    bootloader="grub"
    bootloader_extra=""
else
    echo -e "An EFI system detected, UEFI bootloader installation will be used \n"
    bootmode="EFI"
    bootloader_extra="efibootmgr"

    while true
    do
        echo "Select bootloader:"
        echo "1. Grub"
        echo "2. Refind"
        echo
        read bootloader_selection

        case $bootloader_selection in
            1 ) echo
                echo -e "Grub will be installed as bootloader \n"
                bootloader="grub"
                break;;

            2 ) echo
                echo -e "Refind will be installed as bootloader \n"
                bootloader="refind"
                break;;

            * ) echo
                echo -e "Invalid option, try again \n"
                continue;;
        esac
    done
fi

# Partitions formatting and mounting
while true
do
    echo -e "Path to root partition: \c"
    read root

    if [ ! -e $root ]
        then
            echo -e "Invalid partition, try again \n"
            continue
    fi

    echo -e "Format partition? [y/n]"
    read rootf

    case $rootf in
        [Yy] )  echo
                echo -e "The partition will be formatted and mounted \n"
                mkfs.ext4 $root -L ROOT
                fatal_error $? "formatting the partition"
                break;;

        [Nn] )  echo
                echo -e "The partition will only be mounted \n"
                break;;

        * )     echo
                echo -e "Invalid option, try again \n"
                continue;;
    esac
done

mount $root /mnt
fatal_error $? "mounting the partition"

while true
do
    echo -e "Path to BOOT partition: \c"
    read efi

    if [ ! -e $efi ]
        then
            echo -e "Invalid partition, try again \n"
            continue
    fi

    if [ bootmode == "EFI" ]
    then
        echo -e "Format partition? [y/n]"
        read format_efi_selection

        case $format_efi_selection in
            [Yy] )  echo
                    echo -e "The partition will be formatted and mounted \n"

                    mkfs.fat -F32 $efi
                    fatal_error $? "formatting the partition"

                    fatlabel $efi BOOT
                    fatal_error $? "assigning a label to the EFI partition"
                    break;;

            [Nn] )  echo
                    echo -e "The partition will only be mounted \n"
                    break;;

            * )     echo
                    echo -e "Invalid option, try again \n"
                    continue;;
        esac

    else [ bootmode == "BIOS" ]
        wipefs -a $efi
        fatal_error $? "formatting the partition"

        parted $efi name N "BOOT"
        fatal_error $? "assignning a label to the BOOT partition"
        break
    fi
done

mount $efi /mnt/boot -m
fatal_error $? "mounting the partition"

while true
do
    echo
    echo "Use SWAP partition? [y/n]"
    read use_swap_selection

    case $use_swap_selection in
        [Yy] )  echo
                echo -e "Write path of SWAP: \c"
                read swap

                if [ ! -e $swap ]
                    then
                        echo -e "Invalid partition, try again \n"
                        continue
                fi

                mkswap $swap -L SWAP
                fatal_error $? "formatting the partition"
                swapon $swap
                fatal_error $? "mounting the partition"
                break;;
        
        [Nn] )  echo
                echo "No swap partition will be used"
                break;;

        * )     echo
                echo "Invalid option, try again"
                continue;;
    esac
done

while true
do
    echo
    echo "Select Linux kernel"
    echo "1. Stable"
    echo "2. Zen"
    echo
    read kernel_selection

    case $kernel_selection in
        1 ) echo -e "Stable"
            kernel="linux"
            break;;
        
        2 ) echo "Zen"
            kernel="linux-zen"
            break;;

        * ) echo "Invalid option, try again"
            continue;;
    esac
done

pacman-key --init
pacman-key --populate archlinux

pacstrap -K /mnt base base-devel linux-firmware $kernel $kernel-headers mkinitcpio fastfetch curl wget git xdg-user-dirs artix-archlinux-support --noconfirm --needed
fatal_error $? "trying to download and install the system. Please check your internet connection"

fstabgen -U /mnt >> /mnt/etc/fstab

artix-chroot /mnt /bin/bash -e << EOF

    echo -e "Entered to chroot \n"

    # Set Locale and Language
    sed -i "s/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf

    # Clock and Time Zone
    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
    hwclock -w

    # Hostname and hosts
    echo "$hostname" > /etc/hostname

    echo "127.0.0.1   localhost" > /etc/hosts
    echo "::1         localhost" >> /etc/hosts
    echo "127.0.1.1   $hostname.localdomain   $hostname" >> /etc/hosts

    # Add user and sudoers file
    useradd -m -g users -G wheel -s /bin/bash $user

    xdg-user-dirs-update
    sudo -u $user xdg-user-dirs-update

    sed -i "s/^root ALL=(ALL:ALL) ALL/root ALL=(ALL:ALL) ALL\n$user ALL=(ALL:ALL) ALL/" /etc/sudoers

    # Pacman Config File
    sed -i "s|^#Color|Color|" /etc/pacman.conf
    sed -i "s|^#VerbosePkgLists|VerbosePkgLists|" /etc/pacman.conf
    sed -i "s|^#ParallelDownloads = 5|ParallelDownloads = 5|" /etc/pacman.conf

    sed -i "s|^#\\[multilib\\]|\\[multilib\\]|" /etc/pacman.conf
    sed -i "/^\\[multilib\\]/,/#Include = \\/etc\\/pacman.d\\/mirrorlist/ s|#Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist|" /etc/pacman.conf

    echo "
    
    [extra]
    Include = /etc/pacman.d/mirrorlist-arch

    [multilib]
    Include = /etc/pacman.d/mirrorlist-arch
    " >> /etc/pacman.conf

    pacman -Syu --noconfirm --needed

    # Install Fundamentals
    pacman -S neovim networkmanager networkmanager-dinit wireless_tools bluez bluez-dinit bluez-utils blueman $bootloader $bootloader_extra os-prober --noconfirm --needed

    # Enable Services
    ln -s /etc/dinit.d/Networkmanager /etc/dinit.d/boot.d/
    ln -s /etc/dinit.d/bluetooth /etc/dinit.d/boot.d/

    if [[ $bootloader == "grub" ]]
    then
        if [[ $bootmode == "BIOS" ]]
        then
            grub-install --recheck /dev/$(lsblk -ndo pkname $root)
        else
            grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
        fi

        sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet\"|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3\"|" /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg

    else
        refind-install --usedefault $efi --alldrivers
        mkrlconf
        echo "\"Boot with minimal options\" \"ro root=UUID=$(blkid -s UUID -o value $root)\"" > /boot/refind_linux.conf
    fi
EOF

echo "root:$root_password" | artix-chroot /mnt chpasswd
echo "$user:$user_password" | artix-chroot /mnt chpasswd

umount -R /mnt

if [[ $swap != "" ]]
then
    swapoff $swap
    fatal_error $? "unmounting the partitions"
fi

echo
echo "Mz's Arch Installer - Process Succeeded"
echo
echo "Type reboot to finish"