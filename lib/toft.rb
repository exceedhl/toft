require 'toft/node_controller'
require 'toft/file_checker'
require 'toft/chef/chef_attributes'
require 'toft/chef/chef_runner'

module Toft
  class << self
    attr_accessor :cookbook_path, :role_path
  end
  
  def create_node(hostname, ip)
    NodeController.instance.create_node(hostname, ip)
  end
  
  def find(hostname)
    NodeController.instance.nodes[hostname]
  end
  
  def destroy_node(hostname)
    NodeController.instance.destroy_node(hostname)
  end
  
  def node_count
    NodeController.instance.nodes.size
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