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
        conf_file = generate_lxc_config
        cmd "lxc-create -n #{hostname} -f #{conf_file} -t lucid-chef" 
      end
    end
    
    def exists?
      `lxc-ls` =~ /#{@hostname}/
    end
        
    def start
      `lxc-start -n #{@hostname} -d`
      `lxc-wait -n #{@hostname} -s RUNNING`
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
    
    def run_shell(command)
      cmd "chroot #{rootfs} #{command}"
    end
     
    DEST_COOKBOOK_PATH = "/tmp/cookbooks"
    DEST_ROLE_PATH = "/tmp/roles"
    DEST_CHEF_SOLO_PATH = "/tmp/solo.rb" 
    DEST_CHEF_JSON_PATH = "/tmp/solo.json" 
    
    def run_chef(run_list, chef_attributes = nil)
      copy_chef_material
      generate_solo_rb
      generate_json ([] << run_list).flatten, chef_attributes
      run_shell "chef-solo -c #{DEST_CHEF_SOLO_PATH} -j #{DEST_CHEF_JSON_PATH}"
    end
    
    def has_dir?(dirpath)
      dirpath = rootfs + dirpath
      File.exist?(dirpath)
    end
    
    private
    def rootfs
      "/var/lib/lxc/#{@hostname}/rootfs"
    end
  
    def copy_chef_material
      cmd "rm -rf #{rootfs}#{DEST_COOKBOOK_PATH} #{rootfs}#{DEST_ROLE_PATH}"      
      cmd "cp -rf #{Tuft.cookbook_path} #{rootfs}#{DEST_COOKBOOK_PATH}"
      cmd "cp -rf #{Tuft.role_path} #{rootfs}#{DEST_ROLE_PATH}" unless roles_missing?
    end
    
    def roles_missing?
      Tuft.role_path.nil? || Tuft.role_path.empty?
    end
    
    def generate_solo_rb
      solo = <<-EOF
file_cache_path "/tmp/chef-file-cache"
cookbook_path ["#{DEST_COOKBOOK_PATH}"]
      EOF
      solo += "role_path [\"#{DEST_ROLE_PATH}\"]" unless roles_missing?

      File.open("#{rootfs}#{DEST_CHEF_SOLO_PATH}", 'w') do |f|
        f.write(solo);
      end
    end
    
    def generate_json(run_list, chef_attributes)
      run_list = {"run_list" => run_list}
      run_list.merge!(chef_attributes.attributes) unless chef_attributes.nil?
      File.open("#{rootfs}#{DEST_CHEF_JSON_PATH}", 'w') do |f|
        f.write(run_list.to_json);
      end
    end
    
    def generate_lxc_config
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
    
  end
end