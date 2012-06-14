require 'toft/node_controller'
require 'toft/file_checker'
require 'toft/chef/chef_attributes'
require 'toft/chef/chef_runner'
require 'toft/puppet/puppet_runner'

module Toft
  DYNAMIC_IP = "0.0.0.0"
  DOMAIN = "foo"
  
  class << self
    attr_accessor :manifest_path, :cookbook_path, :role_path, :data_bag_path
  end
  
  def create_node(hostname, options = {})
    NodeController.instance.create_node(hostname, options)
  end
  
  def find(name)
    return NodeController.instance.nodes if name === :all
    NodeController.instance.nodes[name] if name.is_a? String
  end
  
  def destroy_node(hostname)
    NodeController.instance.destroy_node(hostname)
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

class Array
  def blank?
    empty?
  end
end
