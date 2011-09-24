Feature: Node management

Scenario: Start or stop node
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then the node "n1" should be running
	When I stop node "n1"
	Then the node "n1" should be stopped
	When I start node "n1"
	Then the node "n1" should be running

Scenario: Create or destroy node 
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then There should be 1 nodes in the environment
	When I add another node "n2" with ip "192.168.20.3"
	Then There should be 2 nodes in the environment
	When I destroy node "n2"
	Then There should be 1 nodes in the environment
	When Node "n1" is destroyed
	Then There should be 0 nodes in the environment	
	
	