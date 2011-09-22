Given /^there are (\d+) courses which do not have the topic "([^"]*)"$/ do |arg1, arg2|
end

Given /^there are (\d+) courses A(\d+), B(\d+) that each have "([^"]*)" as one of the topics$/ do |arg1, arg2, arg3, arg4|
end

When /^I search for "([^"]*)"$/ do |arg1|
end

Then /^I should see the following courses:$/ do
  1.should equal(11)
end