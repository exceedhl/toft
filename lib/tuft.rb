require 'tuft/node_controller'
require 'tuft/chef/chef_attributes'
require 'tuft/chef/chef_runner'

module Tuft
  
  class << self
    attr_accessor :cookbook_path, :role_path
  end
  
end

class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    empty?
  end
end