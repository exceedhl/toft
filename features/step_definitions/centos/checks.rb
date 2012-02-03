Then /^Node "([^"]*)" should have package "([^"]*)" installed in the centos box$/ do |node, package|
  result = find(node).run_ssh("rpm -qa #{package}")
  result.stdout.should include(package)
end
