Then /^Running ssh command "([^"]*)" on "([^"]*)" should succeed$/ do |cmd, node|
  lambda { find(node).run_ssh(cmd) }.should_not raise_error  
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
  r = find(node).run_ssh(cmd)
  r.stdout.should include(s)
end

Then /^the result of running ssh command "([^"]*)" on "([^"]*)" should fail because of "([^"]*)"$/ do |cmd, node, s|
  begin
    r = find(node).run_ssh(cmd)
  rescue CommandExecutionError => e
    e.stdout.should include(s)
  end
end
