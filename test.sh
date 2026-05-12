#! /usr/bin/env bash

root="/dev/nvme0n1p3"
echo "\"Boot with minimal options\" \"ro root=UUID=$(blkid -s UUID -o value $root)\""

# ls /sys/firmware/efi/efivars &> /dev/null

# if (( $? != 0 ))
# then
#     echo -e "EFI system not detected, BIOS bootloader installation will be used \n"
#     echo -e "Grub will be used as bootloader"
#     bootloader="grub"
# else
#     echo -e "A EFI partition detected, UEFI bootloader installation will be used \n"

#     while true
#     do
#         echo "Select bootloader:"
#         echo "1. Grub"
#         echo "2. Refind"
#         echo
#         read bootloader_selection

#         case $bootloader_selection in
#             1 ) echo
#                 echo -e "Grub will be installed as bootloader \n"
#                 bootloader="grub"
#                 extra=""
#                 break;;

#             2 ) echo
#                 echo -e "Refind will be installed as bootloader \n"
#                 bootloader="refind"
#                 extra="efibootmgr"
#                 break;;

#             * ) echo
#                 echo -e "Invalid option, try again \n"
#                 continue;;
#         esac
#     done
# fi

# sudo pacman -S $bootloader $extra

# function fatal_error() {
#     if [ -d "/boot" ]
#     then
#         echo -e "There was an error while $2. Killing the script... \n"
#         exit $1
#     fi
# }

# while true
# do
#     echo -e "Path to EFI partition: \c"
#     read efi

#     if [ ! -e $efi ]
# 	then
#             echo -e "Invalid partition, try again \n"
#             continue
#     fi

#     echo -e "Format partition? [y/n]"
#     read efif

#     case $efif in
#         [Yy] ) echo
#                 echo -e "The partition will be formatted and mounted \n"
#                 format=1;;

#         [Nn] ) echo
#                 echo -e "The partition will only be mounted \n";;

#         * ) echo
# 			fatal_error $? "sleeping peacefully"
# 			continue;;
#     esac

#     if [[ $format == 1 ]]
#     then
#         echo -e "FORMATTING... \n"
#     fi

#     echo -e "MOUNTING... \n"
    
#     break
# done
