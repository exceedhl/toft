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
     
    COOKBOOK_PATH = "/tmp/cookbooks"
    CHEF_SOLO_PATH = "/tmp/solo.rb" 
    CHEF_JSON_PATH = "/tmp/solo.json" 
     
    def run_recipe(recipe)
      copy_cookbooks
      generate_solo_rb
      generate_json recipe
      cmd "chroot #{rootfs} chef-solo -c #{CHEF_SOLO_PATH} -j #{CHEF_JSON_PATH}"
    end
    
    def has_dir?(dirpath)
      dirpath = rootfs + dirpath
      File.exist?(dirpath)
    end
    
    private
    def rootfs
      "/var/lib/lxc/#{@hostname}/rootfs"
    end
  
    def copy_cookbooks
      cmd "rm -rf #{rootfs}#{COOKBOOK_PATH}"      
      cmd "cp -rf cookbooks #{rootfs}#{COOKBOOK_PATH}"
    end
    
    def generate_solo_rb
      solo = <<-EOF
      file_cache_path "/tmp/chef-file-cache"
      cookbook_path ["#{COOKBOOK_PATH}"]
      role_path nil
      log_level :info
      EOF

      File.open("#{rootfs}#{CHEF_SOLO_PATH}", 'w') do |f|
        f.write(solo);
      end
    end
    
    def generate_json(recipe)
      json = <<-EOF
      { "run_list": "recipe[#{recipe}]" }
      EOF
      File.open("#{rootfs}#{CHEF_JSON_PATH}", 'w') do |f|
        f.write(json);
      end
    end
  end
end