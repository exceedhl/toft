Given /^I have a clean running node n1$/ do
  @n1.start
  @n1.rm "/tmp/stub"
end

When /^I add another node "([^"]*)" with ip "([^"]*)"$/ do |node, ip|
  create_node node, {:ip => ip, :type => CONTAINER_TYPE}
end

When /^I add another node "([^"]*)"$/ do |node|
  n = create_node node, {:type => CONTAINER_TYPE}
  n.start
end

When /^I destroy node "([^"]*)"$/ do |node|
  destroy_node node
end

When /^Node "([^"]*)" is destroyed$/ do |node|
  find(node).destroy
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

Then /^Node "([^"]*)" should have ip address same with that obtained from inside it through ssh$/ do |node|
  n = find(node)
  n.run_ssh("ifconfig eth0 | grep 'inet addr:'").stdout.should include(n.ip)
end

When /^I add cname "([^"]*)" to "([^"]*)"$/ do |cname, node|
  find(node).add_cname cname
end

When /^I remove cname "([^"]*)" from "([^"]*)"$/ do |cname, node|
  find(node).remove_cname cname
end
