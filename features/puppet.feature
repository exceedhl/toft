
Feature: Puppet support

Scenario: Run Puppet manifest on nodes 
	Given I have a clean running node n1
	When I run "manifest[test]" on node "n1"
	Then Node "n1" should have file or directory "/tmp/stub/dir"
