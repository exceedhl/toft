Given /^I have a node "([^"]*)" with ip "([^"]*)"$/ do |hostname, ip|
  @controller.create_node hostname, ip
  @controller.nodes['n1'].run_shell "rm -rf /tmp/stub"
end

When /^I add another node "([^"]*)" with ip "([^"]*)"$/ do |hostname, ip|
  @controller.create_node hostname, ip  
end

When /^I remove node "([^"]*)"$/ do |hostname|
  @controller.destroy_node hostname
end

Then /^There should be ([^"]*) nodes in the environment$/ do |count|
  @controller.nodes.size.should == count.to_i
end

Then /^the node "([^"]*)" should be stopped$/ do |hostname|
  @controller.nodes[hostname].should_not be_running
end

When /^I start node "([^"]*)"$/ do |hostname|
  @controller.nodes[hostname].start
end

When /^I stop node "([^"]*)"$/ do |hostname|
  @controller.nodes[hostname].stop
end

Then /^the node "([^"]*)" should be running$/ do |hostname|
  @controller.nodes[hostname].should be_running
end

