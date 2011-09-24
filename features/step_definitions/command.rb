Then /^Running ssh command "([^"]*)" on "([^"]*)" should succeed$/ do |cmd, node|
  @controller.nodes[node].run_ssh(cmd).should be_true
end

Then /^Running ssh command "([^"]*)" on "([^"]*)" should fail$/ do |cmd, node|
  lambda { @controller.nodes[node].run_ssh(cmd) }.should raise_error
end

Then /^Rm "([^"]*)" on "([^"]*)" should fail$/ do |dir, node|
  lambda { @controller.nodes[node].rm(dir) }.should raise_error  
end

Then /^Rm "([^"]*)" on "([^"]*)" should succeed$/ do |dir, node|
  lambda { @controller.nodes[node].rm(dir) }.should_not raise_error  
end

Then /^the result of running ssh command "([^"]*)" on "([^"]*)" should contain "([^"]*)"$/ do |cmd, node, s|
  @controller.nodes[node].run_ssh(cmd) do |output|
    output.should include(s)
  end
end