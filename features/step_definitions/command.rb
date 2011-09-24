Then /^Running shell command "([^"]*)" on "([^"]*)" should succeed$/ do |cmd, node|
  @controller.nodes[node].run_shell(cmd).should be_true
end

Then /^Running shell command "([^"]*)" on "([^"]*)" should fail$/ do |cmd, node|
  lambda { @controller.nodes[node].run_shell(cmd) }.should raise_error
end

Then /^Rm "([^"]*)" on "([^"]*)" should fail$/ do |dir, node|
  lambda { @controller.nodes[node].rm(dir) }.should raise_error  
end

Then /^Rm "([^"]*)" on "([^"]*)" should succeed$/ do |dir, node|
  lambda { @controller.nodes[node].rm(dir) }.should_not raise_error  
end