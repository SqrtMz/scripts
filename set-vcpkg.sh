#! /usr/bin/env bash

if [ ! -e $VCPKG_ROOT ]
then
	export VCPKG_ROOT="${HOME}/.local/share/vcpkg"
fi

git clone https://github.com/microsoft/vcpkg $VCPKG_ROOT

sudo pacman -S vcpkg --noconfirm --needed

if (( $? != 0 ))
then
	$VCPKG_ROOT/bootstrap-vcpkg.sh
fi

echo
echo -e "VCPKG has been installed."
echo -e "Remember to add the next environment variables to your shell to make vcpkg accessible:\n"
echo -e "VCPKG_ROOT=\${HOME}/.local/share/vcpkg (or wherever you want to save the vcpkg repo)"
echo -e "PATH=VCPKG_ROOT:\$PATH"
