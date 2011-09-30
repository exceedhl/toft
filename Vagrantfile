Vagrant::Config.run do |config|
  config.vm.define :ubuntu do |config|
    config.vm.box = "ubuntu-1104-server-i386"
    config.vm.network "33.33.33.11"
    config.vm.share_folder("v-root2", "/home/vagrant/code", ".", :nfs => true)
    config.vm.provision :shell, :path => "scripts/ubuntu/bin/install-chef-ubuntu.sh"
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "scripts/cookbooks"
      chef.add_recipe("lxc")
    end
  end

  config.vm.define :centos6i386 do |config|
    config.vm.box = "centos6-i386"
    config.vm.network "33.33.33.12"
    config.vm.share_folder("v-root1", "/home/vagrant/code", ".", :nfs => true)
  end

  config.vm.define :centos6x86_64 do |config|
    config.vm.box = "centos6-x86_64"
    config.vm.network "33.33.33.13"
    config.vm.share_folder("v-root3", "/home/vagrant/code", ".", :nfs => true)
  end

end
