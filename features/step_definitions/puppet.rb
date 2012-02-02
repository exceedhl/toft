When /^I run puppet manifest "([^"]*)" on node "([^"]*)"$/ do |run_list, node|
  find(node).run_puppet run_list
end

When /^I run puppet manifest "([^"]*)" with config file "([^"]*)" on node "([^"]*)"$/  do |run_list, conf_file, node|
  find(node).run_puppet(run_list, :conf_file => conf_file)
end
