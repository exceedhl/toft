Vagrant::Config.run do |config|
  config.vm.define :u386 do |config|
    config.vm.box = "ubuntu-1104-server-i386"
    config.vm.network :hostonly, "33.33.33.11"
    config.vm.share_folder("v-root2", "/home/vagrant/code", ".", :nfs => true)
  end
  
  config.vm.define :u64 do |config|
    config.vm.box = "ubuntu-1104-server-amd64"
    config.vm.network :hostonly, "33.33.33.14"
    config.vm.boot_mode = :gui
    config.vm.share_folder("v-root4", "/home/vagrant/code", ".", :nfs => true)
  end

  config.vm.define :c386 do |config|
    config.vm.box = "centos6-i386"
    config.vm.network :hostonly, "33.33.33.12"
    config.vm.share_folder("v-root1", "/home/vagrant/code", ".", :nfs => true)
  end

  config.vm.define :c64 do |config|
    config.vm.box = "centos6-x86_64"
    config.vm.network :hostonly, "33.33.33.13"
    config.vm.share_folder("v-root3", "/home/vagrant/code", ".", :nfs => true)
  end

end
