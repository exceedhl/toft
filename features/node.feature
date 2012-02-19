Feature: Node management

Scenario: Start or stop node
	Given I have a clean running node n1
	Then the node "n1" should be running
	When I stop node "n1"
	Then the node "n1" should be stopped
	When I start node "n1"
	Then the node "n1" should be running
	
Scenario: Add and remove cnames for a node
	Given I have a clean running node n1
	And I add another node "n2"
	When I add cname "cn1" to "n1"
	Then Running ssh command "ping -c 1 cn1" on "n2" should succeed	
	When I remove cname "cn1" from "n1"
	Then Running ssh command "ping -c 1 cn1" on "n2" should fail
	And Node "n2" is destroyed

Scenario: Create node only by name and fetch their info
	Given I have a clean running node n1
	When I add another node "n3"
	Then Running ssh command "ping -c 1 n1" on "n3" should succeed
	And Running ssh command "ping -c 1 n3" on "n1" should succeed
	And Node "n1" should have ip address same with that obtained from inside it through ssh
	And Node "n3" should have ip address same with that obtained from inside it through ssh
	And Hostname of Node "n1" should match its name
	And Node "n3" is destroyed
	
Scenario: Create or destroy node 
	Given I have a clean running node n1
	Then There should be 1 nodes in the environment
	When I add another node "n2" with ip "192.168.20.3"
	Then There should be 2 nodes in the environment
	When I destroy node "n2"
	Then There should be 1 nodes in the environment	
	
Scenario: Change hostname used internally for a specific host
  Given I have a clean running node n1
  And I change the internal hostname for "n1" to "correct.puppet.com"
  Then the result of running ssh command "hostname" on "n1" should contain "correct.puppet.com"
