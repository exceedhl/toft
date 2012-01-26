When /^I run "([^"]*)" on node "([^"]*)"$/ do |run_list, node|
  find(node).run_chef run_list
end
