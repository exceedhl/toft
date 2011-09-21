Feature: Sample features

Scenario: Test some recipe
	Given the node "test1" with ip "192.168.20.2" is running
	When I apply recipe "sample" to the node "test1"
	Then directory "/var/tmp/test" should exist		
