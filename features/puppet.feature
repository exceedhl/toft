Feature: Puppet support

Scenario: Run Puppet manifest on nodes
	Given I have a clean running node n1
  When I run puppet manifest "test.pp" on node "n1"
  Then Node "n1" should have file or directory "/tmp/puppet_test"

Scenario: Run puppet manifest with included nodes
  Given I have a clean running node n1
  And I change the internal hostname for "n1" to "correct.puppet.com"
  And I run puppet manifest "site.pp" on node "n1"
  Then Node "n1" should have file or directory "/tmp/puppet_test_correct"
  And Node "n1" should have file or directory "/tmp/puppet_test_default"
  And Node "n1" should have not file or directory "/tmp/puppet_test_incorrect"

Scenario: Run puppet manifest with modules
  Given I have a clean running node n1
  When I run puppet manifest "test_module.pp" with config file "puppet_modules.conf" on node "n1"
  Then Node "n1" should have file or directory "/tmp/puppet_test_module"

Scenario: Run puppet manifest with static files being served by fileserver
  Given I have a clean running node n1
  When I run puppet manifest "test_fileserver.pp" with config file "puppet_fileserver.conf" on node "n1"
  Then Node "n1" should have file or directory "/tmp/puppet_test_fileserver"

Scenario: Run puppet manifest with template dir configuration
  Given I have a clean running node n1
  When I run puppet manifest "test_template.pp" with config file "puppet_template.conf" on node "n1"
  Then Node "n1" should have file or directory "/tmp/puppet_test_template"
