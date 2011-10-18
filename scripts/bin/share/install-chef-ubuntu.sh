#!/bin/bash

username=`id -nu`	
if [ ! "$username" = "root" ]; then
	echo "This command has to be run as root!"
	exit 1
fi

echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | tee /etc/apt/sources.list.d/opscode.list

mkdir -p /etc/apt/trusted.gpg.d
gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
gpg --export packages@opscode.com | tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
apt-get update
apt-get install ucf --force-yes -y
yes | apt-get install opscode-keyring --force-yes -y # permanent upgradeable keyring

export DEBIAN_FRONTEND=noninteractive
apt-get install chef --force-yes -qy 