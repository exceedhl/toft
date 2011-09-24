require 'net/ssh'
require 'ping'

module Tuft
  class Node
    PRIVATE_KEY = <<-EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxPQo3sgDdmqIVK9d3iqJlKI3q+uToiAVbQDk7Viv4sxJTKbI
X0cAySqxwc5/4lKZ0bQBJW2ayBUB31lhNEUfSGBQeriO2YXNRxvezcKUTiWqVFiU
9U2B97Si+uvU6uH+l5XRBf7jgPXEIxsjtCOHPpyoC5edqMCWTH45bDU+lrfvYDGQ
IRYVBjG8fANDZeyZx6Y9/M8dl9Pv7sudwULJvf0smACrk9AenVoq3Y8tNNDpejFw
eZTtLQA8lBxsE+VMfTHyEfBTt2F/w10o/+0vr2g8f2wGqtcBYZa9c67f2S5eNihr
Pxwz3zgCav6kWqb/ucm0pNH69m4JGebMhOVbYQIDAQABAoIBAQCrR7KrW8I3HxqE
myXE6bVQP2qu5mYznjdD3n04M+JyGDq+oGStBzCVwb1o0E7C4hbHGgXNKO5shmhk
dnRkYqB77tbOguYoIYaOCpzO0CLtezAPviF82vTmGH+MO7+krPkdlrp6vlnXcuQp
q5Z3OFaLiu1Rd38ynJmY2ETT59IQe0hfatGbOFLwOrcg921pPHYveDIsGpL/zU7M
0m2kNL+NK7GE8pG2ApJPFxAH24DhI6p9BvzYuOz5XspPZlH1YfD4PIlGwFQvBfOe
hfZbvlDQntlqxl2hB4jHsqNcl3nkZJkTrDmqtYf7yn07ZLhUf9IBkJgqa7Hd8RSz
gFHTn3KJAoGBAPvVOxujwPlLiOZZ+jivUFsD7tehUjoxWv/dycm8oZSmHy5kRBzq
NzFS5VqKBEfSA0ZuN3eUF5pTQAS8XoDXaLd/pVH4FoWARCj06QIJU39gq3q+06cC
H1m1WkVRVzo9UsT+tXe7LNKi8Qwd97z6NMs4cqMaY8kdpzXUguPlCyAHAoGBAMg2
daDiqBQLvHxtFtIY0USPIoT/l+DiHA5ABU/J3hbImdwZJTFnN744JqTnyeuXMSgd
Y33qO9qdi48SGqzm23jahncINYx+4eSdxkiSTn7APDH5g9hDkWwm+FWa/FZigWzt
XbVdLy1E/3oBzyUkIYFDHk25mAwOJI4h1p7qdn9XAoGAMtpiLzioFS9Nm8Z7osq0
HUz0BBMNebbRu21b/CLdNhk9nq6cmoIpVwp4Sgooxx//jU9gYANFqOI6wToQk0/s
U3GxPpYsZhT6rpKWItUjSUuKFSVHtCfXkNPwQKMmTBpqBmGw31aqvHYu2tWKW1zj
IE5rx8ficpBMXbBmJgLwdi0CgYBdgyI5vOOoSTsGGqW4B6NmlDwZRpAXl0RnW3uf
ore6iINki9IVWxJsJCnYh/KFuR5akC9yFj9Sgpc2gcw3ybPkpJx9aDYqovC7KP39
02gaR4tWBCaSkiyQCTugMD1/046D4/IKzbVFPZ7dy46G2HNVvpWe0/qyVsC4KhHm
M7iZDQKBgQDQaZy+TMuc8mxBavThqHEHpNHAlo/xBXknwBVc0sAs5e94caFklIOG
8KKrc4GucWfDunqEhDBS8nRrATQhSSV8qBrMIWbhsCNEA6VJrCl70k3PArpVXCj9
u1StRY//+2thpgAgM6ILfHNkJW+3lQ6xnSNCVLKCIc6ECLukSKcZjg==
-----END RSA PRIVATE KEY-----    
    EOF

    def initialize(hostname, ip)
      @hostname = hostname
      @ip = ip
      unless exists?
        conf_file = generate_lxc_config
        cmd "lxc-create -n #{hostname} -f #{conf_file} -t lucid-chef" 
      end
      @chef_runner = Tuft::Chef::ChefRunner.new("#{rootfs}") do |chef_command|
        run_shell chef_command
      end
    end

    def exists?
      `lxc-ls` =~ /#{@hostname}/
    end

    def start
      `lxc-start -n #{@hostname} -d`
      `lxc-wait -n #{@hostname} -s RUNNING`
      wait_ssh_ready
    end

    def stop
      `lxc-stop -n #{@hostname}`
      `lxc-wait -n #{@hostname} -s STOPPED`
    end

    def destroy
      stop
      `lxc-destroy -n #{@hostname}`
    end

    def running?
      `lxc-info -n #{@hostname}` =~ /RUNNING/
    end

    def run_shell(command)
      raise ArgumentError, "Trying to run empty command on node #{@hostname}", caller if command.blank?
      Net::SSH.start(@ip, "root", :key_data => [PRIVATE_KEY]) do |ssh|
        ssh.exec! command do |ch, stream, data|
          if stream == :stderr
            raise RuntimeError, data, caller
          else
            puts data
          end
        end
      end
      return true
    end

    def rm(dir)
      raise ArgumentError, "Illegal dir path: [#{dir}]", caller if dir.blank? || dir[0] != ?/
      cmd "rm -rf #{rootfs}#{dir}"
    end

    def run_chef(run_list, chef_attributes = nil)
      @chef_runner.run run_list, chef_attributes
    end

    def has_dir?(dirpath)
      dirpath = rootfs + dirpath
      File.exist?(dirpath)
    end

    private
    def rootfs
      "/var/lib/lxc/#{@hostname}/rootfs"
    end

    def wait_ssh_ready
      while true
        netstat = `lxc-netstat --name #{@hostname} -ta`        
        break if netstat =~ /ssh/
      end
      while true
        break if Ping.pingecho @ip, 0.1
        sleep 0.5
      end
      puts "SSH connection on #{@ip} is ready..."
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