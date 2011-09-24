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
  find(node).run_chef run_list, Tuft::ChefAttributes.new(table)
end

When /^I set the role path to empty$/ do
  Tuft.role_path = ""
  @n1.rm "/tmp/*"
end

Then /^Running chef "([^"]*)" on node "([^"]*)" should succeed$/ do |run_list, node|
  result = false
  lambda { result = find(node).run_chef(run_list) }.should_not raise_error
  result.should be_true
end

When /^I set the cookbook path to empty$/ do
  Tuft.cookbook_path = ""
  @n1.rm "/tmp/*"  
end

Then /^Running chef "([^"]*)" on node "([^"]*)" should fail$/ do |run_list, node|
  lambda { find(node).run_chef(run_list) }.should raise_error
end