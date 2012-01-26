When /^I run puppet manifest "([^"]*)" on node "([^"]*)"$/ do |run_list, node|
  find(node).run_puppet run_list
end
