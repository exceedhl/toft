$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'toft'

CHEF_FIXTURE_PATH = File.dirname(__FILE__) + '/../../fixtures/chef'

World(Toft)

include Toft
n1 = create_node "n1", "192.168.20.2", "centos-6"

Before do
  Toft.cookbook_path = CHEF_FIXTURE_PATH + '/cookbooks'
  Toft.role_path = CHEF_FIXTURE_PATH + '/roles'

  @n1 = n1
end

at_exit do
  # n1.destroy
end