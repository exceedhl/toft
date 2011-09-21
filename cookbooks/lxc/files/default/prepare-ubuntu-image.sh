#!/bin/bash

cache="/var/cache/lxc/ubuntu"

arch=$(arch)
if [ "$arch" == "x86_64" ]; then
    arch=amd64
fi

if [ "$arch" == "i686" ]; then
    arch=i386
fi

if [ -e "$cache/rootfs-$arch" ]; then
	echo "Cache rootfs already exists!"
	exit 0
fi

packages=dialog,apt,apt-utils,resolvconf,iproute,inetutils-ping,dhcp3-client,ssh,lsb-release,wget,gpgv,gnupg,ruby,rubygems1.8

# check the mini ubuntu was not already downloaded
mkdir -p "$cache/partial-$arch"
if [ $? -ne 0 ]; then
	echo "Failed to create '$cache/partial-$arch' directory"
	exit 1
fi

# download a mini ubuntu into a cache
echo "Downloading ubuntu minimal ..."
debootstrap --verbose --variant=minbase --components=main,universe --arch=$arch --include=$packages lucid $cache/partial-$arch
if [ $? -ne 0 ]; then
	echo "Failed to download the rootfs, aborting."
	exit 1
fi

mv "$cache/partial-$arch" "$cache/rootfs-$arch"
echo "Download complete."



