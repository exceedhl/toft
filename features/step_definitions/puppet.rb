When /^I run puppet manifest "([^"]*)" on node "([^"]*)"$/ do |run_list, node|
  find(node).run_puppet run_list
end

When /^I run puppet manifest "([^"]*)" with config file "([^"]*)" on node "([^"]*)"$/  do |run_list, conf_file, node|
  find(node).run_puppet(run_list, :conf_file => conf_file)
end

When /^node "([^"]*)" has the configuration settings:$/ do |node, table|
  r = find(node)
  r.run_ssh("echo '[user]'  >> /etc/puppet/puppet.conf")
  table.hashes.each do |hash|
    r.run_ssh("echo '#{hash[:key]} = #{hash[:value]}' >> /etc/puppet/puppet.conf")
  end
end
