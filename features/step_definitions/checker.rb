Then /^Node "([^"]*)" should have not file or directory "([^"]*)"$/ do |node, dirpath|
  find(node).file(dirpath).should_not be_exist
end

Then /^Node "([^"]*)" should have file or directory "([^"]*)"$/ do |node, dirpath|
  find(node).file(dirpath).should be_exist
end

Then /^Node "([^"]*)" should have "([^"]*)" "([^"]*)" owned by user "([^"]*)" and group "([^"]*)" with permission "([^"]*)"$/ do |node, type, dirpath, user, group, mode|
  file = find(node).file(dirpath)
  file.filetype.should == type
  file.owner.should == user
  file.group.should == group
  file.mode.should == mode
end