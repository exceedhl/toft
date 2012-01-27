Feature: Puppet support

Scenario: Run Puppet manifest on nodes
	Given I have a clean running node n1
  When I run puppet manifest "test.pp" on node "n1"
  Then Node "n1" should have file or directory "/tmp/puppet_test"

Scenario: Run puppet manifest with specific hostname
  Given I have a clean running node n1 with hostname "correct.puppet.com"
  Then Node "n1" should have file or directory "/tmp/puppet_test_correct"
  And Node "n1" should have file or directory "/tmp/puppet_test_default"
  And Node "n1" should not have file or directory "/tmp/puppet_test_incorrect"
