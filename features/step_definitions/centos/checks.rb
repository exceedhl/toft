Then /^Node "([^"]*)" should have package "([^"]*)" installed in the centos box$/ do |node, package|
  result = find(node).run_ssh("rpm -qa #{package}")
  result.stdout.should include(package)
end

Then /^Node "([^"]*)" should have service "([^"]*)" running in the centos box$/ do |node, service|
  result = find(node).run_ssh("ps -ef | grep -v grep | grep #{service} | wc -l")
  result.stdout.strip!.should == "1"
end
