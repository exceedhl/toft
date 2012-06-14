When /^I run "([^"]*)" on node "([^"]*)"$/ do |run_list, node|
  find(node).run_chef run_list
end

When /^I run recipes on node "([^"]*)":$/ do |node, recipes_table|
  recipes = []
  recipes_table.hashes.each do |row|
    recipes << row[:recipe]
  end
  find(node).run_chef recipes
end

When /^I run "([^"]*)" on node "([^"]*)" and overwrite attributes with:$/ do |run_list, node, table|
  find(node).run_chef run_list, {:attributes => Toft::ChefAttributes.new(table)}
end

When /^I set the role path to empty$/ do
  Toft.role_path = ""
  @n1.rm "/tmp/*"
end

Then /^Running chef "([^"]*)" on node "([^"]*)" should succeed$/ do |run_list, node|
  result = false
  lambda { result = find(node).run_chef(run_list) }.should_not raise_error
  result.should be_true
end

When /^I set the cookbook path to empty$/ do
  Toft.cookbook_path = ""
  @n1.rm "/tmp/*"  
end

Then /^Running chef "([^"]*)" on node "([^"]*)" should fail$/ do |run_list, node|
  lambda { find(node).run_chef(run_list) }.should raise_error
end

When /^I run "([^"]*)" on node "([^"]*)" and overwrite attributes with json file "([^"]*)"$/ do |run_list, node, json_file|
  find(node).run_chef run_list, :json => CHEF_FIXTURE_PATH + '/attributes.json'
end

When /^I run "([^"]*)" on node "([^"]*)" and overwrite attributes with json file "([^"]*)" and chef attributes:$/ do |run_list, node, json_file, table|
  find(node).run_chef run_list, {:json => CHEF_FIXTURE_PATH + '/attributes.json', :attributes => Toft::ChefAttributes.new(table)}
end

When /^I add another cookbook "(.*?)"$/ do |cookbook_path|
  Toft.cookbook_path = [CHEF_FIXTURE_PATH + '/cookbooks', CHEF_FIXTURE_PATH + "/#{cookbook_path}"]
end

When /^I add another role dir "(.*?)"$/ do |role_path|
  Toft.role_path = [CHEF_FIXTURE_PATH + '/roles', CHEF_FIXTURE_PATH + "/#{role_path}"]
end

When /^I add another databag dir "(.*?)"$/ do |databag_path|
  Toft.data_bag_path = [CHEF_FIXTURE_PATH + '/data_bags', CHEF_FIXTURE_PATH + "/#{databag_path}"]
end
