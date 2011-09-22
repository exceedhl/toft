$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'tuft'

controller = Tuft::NodeController.new
controller.create_node "n1", "192.168.20.2"
World(Tuft)

Before do
  @controller = controller
end

at_exit do
  controller.destroy_node "n1"
end