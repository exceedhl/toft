#!/bin/bash

apt-get install lxc bridge-utils debootstrap

if [[ ! `ip link ls dev br0` ]]; then
	brctl addbr br0
	ifconfig br0 192.168.20.1 netmask 255.255.255.0 up
	iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	sysctl -w net.ipv4.ip_forward=1
fi

if [[ ! -d /cgroup ]]; then
	mkdir -p /cgroup
fi

if [[ ! `mount | grep cgroup` ]]; then
	mount none -t cgroup /cgroup
fi
