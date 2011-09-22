When /^I run recipe "([^"]*)" on node "([^"]*)"$/ do |recipe, node|
  @controller.nodes[node].run_recipe recipe
end

Then /^Node "([^"]*)" should have directory "([^"]*)"$/ do |node, dirpath|
  @controller.nodes[node].should have_dir(dirpath)
end
