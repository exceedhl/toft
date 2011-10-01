require "bundler/gem_tasks"

desc "clean artifacts"
task :clean do
  `rm -rf pkg`
end

desc "build gem and scripts package"
task :package => [:build, :package_scripts]

task :package_scripts do
  mkdir_p "pkg"
  `tar zcf pkg/toft_ubuntu_scripts-#{Toft::VERSION}.tar.gz scripts/ubuntu`
end
