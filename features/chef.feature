Feature: Chef support

Scenario: Run chef recipe on nodes 
	Given I have a clean running node n1
	When I run "recipe[test]" on node "n1"
	Then Node "n1" should have file or directory "/tmp/stub/dir"

Scenario: Run chef recipe with attributes
	Given I have a clean running node n1
	When I run "recipe[test::attribute]" on node "n1" and overwrite attributes with:
		|key|value|
		|one|one|
		|two.one|two_one|
		|two.two|two_two|
		|three|three|
	Then Node "n1" should have file or directory "/tmp/stub/one"
	Then Node "n1" should have file or directory "/tmp/stub/two_one"
	Then Node "n1" should have file or directory "/tmp/stub/two_two"
	Then Node "n1" should have file or directory "/tmp/stub/three"
	
Scenario: Run multiple chef recipes
	Given I have a clean running node n1
	When I run recipes on node "n1":
		|recipe|
		|recipe[test::role]|
		|recipe[test]|
	Then Node "n1" should have file or directory "/tmp/stub/dir"
	Then Node "n1" should have file or directory "/tmp/stub/role"

Scenario: Run chef role
	Given I have a clean running node n1
	When I run "role[test]" on node "n1"
	Then Node "n1" should have file or directory "/tmp/stub/role"

Scenario: Toft should not deal with empty cookbook and role path
	Given I have a clean running node n1
	When I set the role path to empty
	Then Running chef "recipe[test]" on node "n1" should succeed
	When I set the cookbook path to empty
	Then Running chef "recipe[test]" on node "n1" should fail
	
Scenario: Run chef recipe with json attributes file
	Given I have a clean running node n1
	When I run "recipe[test::attribute]" on node "n1" and overwrite attributes with json file "attributes.json"
	Then Node "n1" should have file or directory "/tmp/stub/one"
	Then Node "n1" should have file or directory "/tmp/stub/two_one"
	Then Node "n1" should have file or directory "/tmp/stub/two_two"
	Then Node "n1" should have file or directory "/tmp/stub/three"

Scenario: Attributes table should override attributes in json file
	Given I have a clean running node n1
	When I run "recipe[test::attribute]" on node "n1" and overwrite attributes with json file "attributes.json" and chef attributes:
		|key|value|
		|one|override|
	Then Node "n1" should have file or directory "/tmp/stub/override"
	Then Node "n1" should have file or directory "/tmp/stub/two_one"
	Then Node "n1" should have file or directory "/tmp/stub/two_two"
	Then Node "n1" should have file or directory "/tmp/stub/three"

Scenario: Run chef recipe with data bags
	Given I have a clean running node n1
	When I run "recipe[test::data_bag]" on node "n1"
	Then Node "n1" should have file or directory "/tmp/stub/bag1item1"
	Then Node "n1" should have file or directory "/tmp/stub/bag1item2"
	Then Node "n1" should have file or directory "/tmp/stub/bag2item1"
	Then Node "n1" should have file or directory "/tmp/stub/bag2item2"

Scenario: Run non-exist recipe

Scenario: Run non-exist role








