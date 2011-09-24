require 'tuft/node'

module Tuft
  class NodeController    
    attr_reader :nodes
    
    def initialize
      @nodes = {}
    end
    
    def create_node(hostname, ip)
      @nodes[hostname] = Tuft::Node.new(hostname, ip)
    end
    
    def destroy_node(hostname)
      @nodes[hostname].destroy
      @nodes.delete hostname
    end
    
    @@instance = NodeController.new
    class << self
      def instance
        @@instance
      end
    end
  end
end