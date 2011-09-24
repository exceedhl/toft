$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'tuft'

Tuft.cookbook_path = File.dirname(__FILE__) + '/../../fixtures/chef/cookbooks'
Tuft.role_path = File.dirname(__FILE__) + '/../../fixtures/chef/roles'

World(Tuft)

include Tuft
n1 = create_node "n1", "192.168.20.2"

Before do
  @n1 = n1
end

at_exit do
  n1.destroy
end