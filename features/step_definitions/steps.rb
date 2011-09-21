nodes = {}

Given /^the node "([^"]*)" with ip "([^"]*)" is running$/ do |hostname, ip|
  nodes = {hostname => ip}
  
  conf_file = prepare_conf hostname, ip
  # cmd "sudo lxc-create -n #{hostname} -f #{conf_file} -t lucid-chef"
  # cmd "sudo lxc-start -n #{hostname} -d"
  # prepare chef
  cmd "sudo ssh #{ip} apt-get install ruby-dev libopenssl-ruby build-essential wget ssl-cert --force-yes -y"
  cmd "sudo ssh #{ip} gem install chef --no-ri --no-rdoc"
  # cmd "sudo ssh #{ip} ln -s /var/lib/gems/1.8/gems/chef-0.10.4/bin/chef-solo /usr/local/bin/chef-solo"
  
  cmd "tar zcf /tmp/cookbooks.tar.gz code/cookbooks"
  cmd "sudo scp /tmp/cookbooks.tar.gz #{ip}:/tmp/cookbooks.tar.gz"
  cmd "sudo ssh #{ip} tar zxf /tmp/cookbooks.tar.gz -C /tmp"
  
  solo = <<-EOF
  file_cache_path "/tmp/chef-file-cache"
  cookbook_path ["/tmp/code/cookbooks"]
  role_path nil
  log_level :info
  EOF
  
  File.open("/tmp/solo.rb", 'w') do |f|
    f.write(solo);
  end
  
  cmd "sudo scp /tmp/solo.rb #{ip}:/tmp/solo.rb"
end

When /^I apply recipe "([^"]*)" to the node "([^"]*)"$/ do |recipe, hostname|
  json = <<-EOF
  { "run_list": "recipe[#{recipe}]" }
  EOF
  File.open("/tmp/foo.json", 'w') do |f|
    f.write(json);
  end
  
  cmd "sudo scp /tmp/foo.json #{nodes[hostname]}:/tmp/foo.json"
  
  cmd "sudo ssh #{nodes[hostname]} chef-solo -c /tmp/solo.rb -j /tmp/foo.json"
  
end

Then /^directory "([^"]*)" should exist$/ do |dirpath|
end

def cmd(cmd)
  raise "Command execution failed: [#{cmd}]" unless system cmd
end

def prepare_conf(hostname, ip)
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