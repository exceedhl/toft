require 'tuft/node_controller'
require 'tuft/chef_attributes'

module Tuft
  
  class << self
    attr_accessor :cookbook_path, :role_path
  end
  
end