$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'tuft'

controller = Tuft::NodeController.new
World(Tuft)

Before do
  @controller = controller
end