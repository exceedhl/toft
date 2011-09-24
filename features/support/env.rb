$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'tuft'

Tuft.cookbook_path = File.dirname(__FILE__) + '/../../fixtures/chef/cookbooks'
Tuft.role_path = File.dirname(__FILE__) + '/../../fixtures/chef/roles'

controller = Tuft::NodeController.new
controller.create_node "n1", "192.168.20.2"

World(Tuft)

Before do
  @controller = controller
end

at_exit do
  controller.destroy_node "n1"
end