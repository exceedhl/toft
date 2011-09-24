Feature: Run shell command on node

Scenario: Run command on node successfully
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then Running shell command "" on "n1" should fail
	And Running shell command "ps" on "n1" should succeed
	And Running shell command "non-exist-command" on "n1" should fail
	And Running shell command "netstat -nr" on "n1" should succeed
	
Scenario: Test rm
	Given I have a clean running node "n1" with ip "192.168.20.2"
	Then Rm "" on "n1" should fail
	And Rm "tmp/*" on "n1" should fail
	And Rm "/tmp/*" on "n1" should succeed