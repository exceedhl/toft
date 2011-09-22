module Tuft
  class NodeController    
    attr_reader :nodes
    
    def initialize
      @nodes = {}
    end
    
    def create_node(hostname, ip)
      @nodes[hostname] = Node.new(hostname, ip)
    end
    
    def destroy_node(hostname)
      @nodes[hostname].destroy
      @nodes.delete hostname
    end
  end
  
  class Node
    def initialize(hostname, ip)
      @hostname = hostname
      @ip = ip
      unless exists?
        conf_file = prepare_conf
        cmd "lxc-create -n #{hostname} -f #{conf_file} -t lucid-chef" 
      end
    end
    
    def exists?
      `lxc-ls` =~ /#{@hostname}/
    end
    
    def prepare_conf
      conf = <<-EOF
      lxc.network.type = veth
      lxc.network.flags = up
      lxc.network.link = br0
      lxc.network.name = eth0
      lxc.network.ipv4 = #{@ip}/24
    EOF
      conf_file = "/tmp/#{@hostname}-conf"
      File.open(conf_file, 'w') do |f|
        f.write(conf);
      end
      return conf_file
    end
    
    def cmd(cmd)
      puts "Executing command: [#{cmd}]"
      raise "Command execution failed: [#{cmd}]" unless system cmd
    end
    
    def start
      while true
        `lxc-start -n #{@hostname} -d`
        break if running?
      end
    end

    def stop
      `lxc-stop -n #{@hostname}`
    end
    
    def destroy
      cmd "lxc-destroy -n #{@hostname}"
    end
    
    def running?
      `lxc-info -n #{@hostname}` =~ /RUNNING/
    end
  end
end