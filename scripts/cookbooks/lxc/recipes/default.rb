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

template "/usr/lib/lxc/templates/lxc-lucid" do
  source "lxc-lucid"
  mode "0755"
  action :create
end

template "/usr/lib/lxc/templates/lxc-natty" do
  source "lxc-natty"
  mode "0755"
  action :create
end

template "/usr/lib/lxc/templates/lxc-centos-6" do
  source "lxc-centos-6"
  mode "0755"
  action :create
end