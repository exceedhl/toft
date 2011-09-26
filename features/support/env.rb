$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'toft'

Toft.cookbook_path = File.dirname(__FILE__) + '/../../fixtures/chef/cookbooks'
Toft.role_path = File.dirname(__FILE__) + '/../../fixtures/chef/roles'

World(Toft)

include Toft
n1 = create_node "n1", "192.168.20.2"

Before do
  @n1 = n1
end

at_exit do
  n1.destroy
end