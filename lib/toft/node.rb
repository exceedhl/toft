require 'observer'
require 'net/ssh'
require 'ping'
require 'toft/file_checker'

module Toft
  class Node
    PRIVATE_KEY = <<-EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAwoLge1y9wEcy2WC7CDGXuFFDt+9Zvh+QulfDIbZkpYF7YBw6
O3mYTUpucwnqMhnd9jini8bsQghJF3wwxdWmtmurcHAEhN6ZljXZwUu2rojh+D+4
PnkOAMPb+w3REmyFYBxfzQ4gBBRXZgKWDTN6Al9hYRFTVSsZJCKJFK+GsWBSc5ie
l6IuUnfCbTwvORWVV6g7nGQ5x0JTnApG0qNFDprFkBsLbvHlB6A3lBtHQfJ7W/cZ
QXi3LXawD4bhWAl/CHxZHXGpJM7+tREz2yhOoPcHUwwv0xHqe/wBxmJmq84kZ8Co
lTi9Y5xNXKDiS6svMDgt3ShpkWcvQ+LE3PhUVQIDAQABAoIBAQCEvfZemeLw9mXw
TYA2TknhQqw5OYIAKuCFGuGS/ztea6f75iejcQ8MKDCKF4kZGegNYYqN7HpNcgQX
n+xVBsJYGdCM0hVza8pa5XMu4/HO2KGF3k5pbAmvYfqdMUeuEBtRhOuoL+yPfCZM
+pTWe3vXZKo7KSy6ocftjhgI4uTD5OtUHZe+Q61K8Ng5723kk4KcbZo4LHEvj4C2
nnplt9uxiS04qTPuJohxiwE1pbSybaH5Kndfvzmh1A1q/HKCZNhQKK/jhgvDBtBu
hiDfPtKdEeSTbFm11ckJBE1HPdAXoppxwDHQzcq82+vNJdB2P2TsMPklPRb6FuDa
dCQ0B5IBAoGBAPUlki+Q6yC4snhJ7r0ipIiMimB+Q6UlrE6ayyc3s/akjvTaqs2z
tcZTPUVVLjs0WIRIYwOWMcNmMZoi2s8nGsDiljmd1+smWHPK8A9X8pSUH6Z5k7sS
fzno3ytRXohyR2UB6iuUoT3F0VEnaaDjLlNk77DYusAmMsrm8W5PkMHVAoGBAMsf
aocc8yrwC7Wa0xfeNreK4F3OayqP6xAu0aSXqj1gtJ6HTTgY2g4jqtnV40NVXwHK
7zA4ie5IfmQ/672Te+9ifeWYNqv8faHDJwZFbZ2LwPW/lm5i4Ezn9KMmpLTz+6yj
f1bS+Y0NYyxfs1nn7Lx/kvuJVdIV+Ktma+ZHGAiBAoGAHo6NV0KAHHcJP/cvPAIa
ci7afMagVfCJNs8SrZPC6eZ/L0QmcDeLW+o6Q+8nMRgIRIzlUqghEdMmMalQjuu3
6P0Vbp8fL996vQw5uh/jS+Pewhh7cqEOnMBLORIOb4GXJp8DemUvaAzFV5FLGFPZ
DWoSen+5X4QjZqk8xNxEFfUCgYB+xR6xMMo69BH6x6QTc2Zm6s/Y++k6aRPlx7Kj
rNxc7iwL/Jme9zOwO2Z4CduKvI9NCSB60e6Tvr7TRmmUqaVh4/B7CKKmeDDYcnm6
mj4tY3mMZoQ2ZJNkrCesY4PMQ7HBL1FcGNQSylYo7Zl79Rl1E5HiVvYu5fOK1aNl
1t0TAQKBgQCaN91JXWJFXc1rJsDy365SKrX00Nt8rZolFQy2UhhERoCxD0uwbOYm
sfWYRr79L2BZkyRHmuxCD24SvHibDev+T0Jh6leXjnrwd/dj3P0tH8+ctET5SXsD
CQWv13UgQjiHgQILXSb7xdzpWK1wpDoqIEWQugRyPQDeZhPWVbB4Lg==
-----END RSA PRIVATE KEY-----    
    EOF
    
    include Observable

    def initialize(hostname, ip, type)
      @hostname = hostname
      @ip = ip
      unless exists?
        conf_file = generate_lxc_config
        system "lxc-create -n #{hostname} -f #{conf_file} -t #{type.to_s}" 
      end
      @chef_runner = Toft::Chef::ChefRunner.new("#{rootfs}") do |chef_command|
        run_ssh chef_command
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
      changed
      notify_observers(@hostname)
    end

    def running?
      `lxc-info -n #{@hostname}` =~ /RUNNING/
    end

    def run_ssh(command)
      raise ArgumentError, "Trying to run empty command on node #{@hostname}", caller if command.blank?
      error = false
      Net::SSH.start(@ip, "root", :key_data => [PRIVATE_KEY]) do |ssh|
        ssh.exec! command do |ch, stream, data|
          if stream == :stderr
            error = true
          end
          yield data if block_given?
	        puts data
        end
      end
      raise RuntimeError, "Error happened while executing command [#{command}]!", caller if error
      return true
    end
    
    def get_ssh_result(cmd)
      output = ""
      run_ssh(cmd) do |data|
        output += data
      end
      return output
    end

    def rm(dir)
      raise ArgumentError, "Illegal dir path: [#{dir}]", caller if dir.blank? || dir[0] != ?/
      system "rm -rf #{rootfs}#{dir}"
    end

    def run_chef(run_list, params = {})
      @chef_runner.run run_list, params
    end

    def file(path)
      FileChecker.new(rootfs, path)
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
  end
end
