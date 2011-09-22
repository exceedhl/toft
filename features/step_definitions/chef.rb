When /^I run recipe "([^"]*)" on node "([^"]*)"$/ do |recipe, node|
  @controller.nodes[node].run_recipe recipe
end

When /^I run recipe "([^"]*)" on node "([^"]*)" and overwrite attributes with:$/ do |recipe, node, table|
  @controller.nodes[node].run_recipe recipe, Tuft::ChefAttributes.new(table)
end

Then /^Node "([^"]*)" should have directory "([^"]*)"$/ do |node, dirpath|
  @controller.nodes[node].should have_dir(dirpath)
end
