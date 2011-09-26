Vagrant::Config.run do |config|
  config.vm.define :ubuntu do |config|
    config.vm.box = "ubuntu1104"
    config.vm.network "33.33.33.11"
    config.vm.boot_mode = :gui
    config.vm.share_folder("v-root2", "/vagrant", ".", :nfs => true)
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
