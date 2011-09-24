Feature: Run ssh command on node

Scenario: Run command on node successfully
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then Running ssh command "" on "n1" should fail
	And Running ssh command "ps" on "n1" should succeed
	And Running ssh command "non-exist-command" on "n1" should fail
	And Running ssh command "netstat -nr" on "n1" should succeed
	
Scenario: Test rm
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then Rm "" on "n1" should fail
	And Rm "tmp/*" on "n1" should fail
	And Rm "/tmp/*" on "n1" should succeed
	
Scenario: Check ssh command result
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then the result of running ssh command "ps" on "n1" should contain "sshd"
	