Feature: Chef support

Scenario: Run chef recipe on nodes 
	Given I have a node "n1" with ip "192.168.20.2"
	When I run recipe "test" on node "n1"
	Then Node "n1" should have directory "/tmp/test"
