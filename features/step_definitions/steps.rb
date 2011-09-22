nodes = {}

Given /^the node "([^"]*)" with ip "([^"]*)" is running$/ do |hostname, ip|
  nodes = {hostname => ip}
  
  conf_file = generate_lxc_config hostname, ip
  # cmd "lxc-create -n #{hostname} -f #{conf_file} -t lucid-chef"
  # cmd "lxc-start -n #{hostname} -d"
  
  cmd "cp -rf code/cookbooks #{rootfs(hostname)}/tmp/cookbooks"
  
  solo = <<-EOF
  file_cache_path "/tmp/chef-file-cache"
  cookbook_path ["/tmp/cookbooks"]
  role_path nil
  log_level :info
  EOF
  
  File.open("#{rootfs(hostname)}/tmp/solo.rb", 'w') do |f|
    f.write(solo);
  end
end

When /^I apply recipe "([^"]*)" to the node "([^"]*)"$/ do |recipe, hostname|
  json = <<-EOF
  { "run_list": "recipe[#{recipe}]" }
  EOF
  File.open("#{rootfs(hostname)}/tmp/foo.json", 'w') do |f|
    f.write(json);
  end  
  cmd "chroot #{rootfs(hostname)} chef-solo -c /tmp/solo.rb -j /tmp/foo.json"
end

Then /^directory "([^"]*)" should exist$/ do |dirpath|
  dir = Dir(hostname, dirpath)
  dir.should exist
  dir.should have_permission(0644)
  dir.should belong_to()
end

def cmd(cmd)
  raise "Command execution failed: [#{cmd}]" unless system cmd
end

def rootfs(hostname)
  "/var/lib/lxc/#{hostname}/rootfs"
end

def generate_lxc_config(hostname, ip)
  conf = <<-EOF
  lxc.network.type = veth
  lxc.network.flags = up
  lxc.network.link = br0
  lxc.network.name = eth0
  lxc.network.ipv4 = #{ip}/24
EOF
  conf_file = "/tmp/#{hostname}-conf"
  File.open(conf_file, 'w') do |f|
    f.write(conf);
  end
  return conf_file
end