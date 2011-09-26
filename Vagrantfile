Vagrant::Config.run do |config|
  config.vm.define :toft do |config|
    config.vm.box = "ubuntu-1104-server-i386"
    config.vm.network "33.33.33.11"
    config.vm.share_folder("v-root2", "/home/vagrant/code", ".", :nfs => true)
    config.vm.provision :shell, :path => "scripts/bash/install-chef-ubuntu.sh"
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "scripts/cookbooks"
      chef.add_recipe("lxc")
    end
  end

  config.vm.define :test do |config|
    config.vm.box = "ubuntu1104"
    config.vm.network "33.33.33.12"
    # config.vm.boot_mode = :gui
    config.vm.share_folder("v-root1", "/home/vagrant/code", ".", :nfs => true)
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "scripts/cookbooks"
      chef.add_recipe("lxc")
    end
  end
end
