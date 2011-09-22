%w{lxc bridge-utils debootstrap}.each do |pkg|
  package "#{pkg}"
end

bash "set up networking" do
  code <<-EOH
brctl addbr br0
ifconfig br0 #{node.network.gateway_ip} netmask 255.255.255.0 up
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1
EOH
  not_if "ip link ls dev br0"
end

directory "/cgroup" do
  action :create
end

mount "/cgroup" do
  device "cgroup"
  fstype "cgroup"
  pass 0
  action [:mount, :enable]
end

template "/usr/lib/lxc/templates/lxc-lucid-chef" do
  source "lxc-lucid-chef"
  mode "0755"
  action :create
end

cookbook_file "/usr/local/bin/prepare-ubuntu-image" do
  source "prepare-ubuntu-image"
  mode "0755"
end

bash "create root ssh key " do
  user "root"
  code <<-EOH
  printf "\ny" | ssh-keygen -q -N ""
EOH
end

bash "create ubuntu rootfs" do
  code <<-EOH
/var/tmp/prepare-ubuntu-image.sh
EOH
end
 
