Then /^Running ssh command "([^"]*)" on "([^"]*)" should succeed$/ do |cmd, node|
  find(node).run_ssh(cmd).should be_true
end

Then /^Running ssh command "([^"]*)" on "([^"]*)" should fail$/ do |cmd, node|
  lambda { find(node).run_ssh(cmd) }.should raise_error
end

Then /^Rm "([^"]*)" on "([^"]*)" should fail$/ do |dir, node|
  lambda { find(node).rm(dir) }.should raise_error  
end

Then /^Rm "([^"]*)" on "([^"]*)" should succeed$/ do |dir, node|
  lambda { find(node).rm(dir) }.should_not raise_error  
end

Then /^the result of running ssh command "([^"]*)" on "([^"]*)" should contain "([^"]*)"$/ do |cmd, node, s|
  find(node).get_ssh_result(cmd).should include(s)
end