Given /^I have a clean running node "([^"]*)" with ip "([^"]*)"$/ do |node, ip|
  create_node node, ip
  @n1.start
  @n1.rm "/tmp/stub"
end

When /^I add another node "([^"]*)" with ip "([^"]*)"$/ do |node, ip|
  create_node node, ip  
end

When /^I remove node "([^"]*)"$/ do |node|
  destroy_node node
end

Then /^There should be ([^"]*) nodes in the environment$/ do |count|
  node_count.should == count.to_i
end

Then /^the node "([^"]*)" should be stopped$/ do |node|
  find(node).should_not be_running
end

When /^I start node "([^"]*)"$/ do |node|
  find(node).start
end

When /^I stop node "([^"]*)"$/ do |node|
  find(node).stop
end

Then /^the node "([^"]*)" should be running$/ do |node|
  find(node).should be_running
end

