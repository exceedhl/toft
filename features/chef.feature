Feature: Chef support

Scenario: Run chef recipe on nodes 
	Given I have a node "n1" with ip "192.168.20.2"
	When I run recipe "test" on node "n1"
	Then Node "n1" should have directory "/tmp/dir"

Scenario: Run chef recipe with attributes
	Given I have a node "n1" with ip "192.168.20.2"
	When I run recipe "test::attribute" on node "n1" and overwrite attributes with:
		|key|value|
		|one|one|
		|two.one|two_one|
		|two.two|two_two|
		|three|three|
	Then Node "n1" should have directory "/tmp/one"
	Then Node "n1" should have directory "/tmp/two_one"
	Then Node "n1" should have directory "/tmp/two_two"
	Then Node "n1" should have directory "/tmp/three"
