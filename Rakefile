require "bundler/gem_tasks"

PROJECT_ROOT = File.dirname(__FILE__)
LXC_PACKAGE_NAME = "toft-lxc"

desc "clean artifacts"
task :clean do
  `rm -rf pkg`
  `rm -rf tmp`
end

desc "build gem and scripts package"
task :package => [:build, :package_deb, :package_rpm]

task :package_deb do
  src_dir = "#{PROJECT_ROOT}/scripts"
  content_dir = "#{PROJECT_ROOT}/pkg/#{LXC_PACKAGE_NAME}"
  mkdir_p content_dir
  mkdir_p "#{content_dir}/usr/bin"
  mkdir_p "#{content_dir}/var/cache/lxc"
  mkdir_p "#{content_dir}/usr/lib/lxc/templates"
  cp_r Dir.glob("#{src_dir}/bin/share/*"), "#{content_dir}/usr/bin"
  cp_r Dir.glob("#{src_dir}/bin/ubuntu/*"), "#{content_dir}/usr/bin"
  cp_r Dir.glob("#{src_dir}/lxc-templates/*"), "#{content_dir}/usr/lib/lxc/templates"
  
  post_install_script = <<-eos
#!/bin/sh -e
/usr/bin/lxc-prepare-host
eos
  File.open("#{PROJECT_ROOT}/pkg/toft-lxc-post-install.sh", 'w') { |f| f.write(post_install_script) }
  
  Dir.chdir("pkg") do
    system <<-EOF
    fpm -s dir \
    -t deb \
    -C #{content_dir} \
    -a all \
    -n #{LXC_PACKAGE_NAME} \
    -v #{Toft::VERSION} \
    -m "Huang Liang<exceedhl@gmail.com>" \
    --description "lxc templates and helper provided by toft" \
    -d sudo \
    -d rpm \
    -d dnsutils \
    -d lxc \
    -d bridge-utils \
    -d debootstrap \
    -d dhcp3-server \
    -d bind9 \
    -d ntp \
    --replaces lxc \
    --conflicts apparmor \
    --conflicts apparmor-utils \
    --post-install "#{PROJECT_ROOT}/pkg/toft-lxc-post-install.sh" \
    .
    EOF
  end
end

task :package_rpm do
  src_dir = "#{PROJECT_ROOT}/scripts"
  content_dir = "#{PROJECT_ROOT}/pkg/#{LXC_PACKAGE_NAME}"
  mkdir_p content_dir
  mkdir_p "#{content_dir}/usr/bin"
  mkdir_p "#{content_dir}/var/lib/lxc"
  mkdir_p "#{content_dir}/var/cache/lxc"
  mkdir_p "#{content_dir}/usr/lib/lxc/templates"
  cp_r Dir.glob("#{src_dir}/bin/share/*"), "#{content_dir}/usr/bin"
  cp_r Dir.glob("#{src_dir}/bin/centos/*"), "#{content_dir}/usr/bin"
  cp_r Dir.glob("#{src_dir}/lxc-templates/*"), "#{content_dir}/usr/lib/lxc/templates"
  
  pre_install_script = <<-eos
#!/bin/sh -e
# intsall lxc if not exist
if [[ ! -f /usr/bin/lxc-ls ]]; then
	(cd /tmp && \
	wget http://lxc.sourceforge.net/download/lxc/lxc-0.7.4.tar.gz && \
	tar zxf lxc-0.7.4.tar.gz && \
	cd lxc-0.7.4 && \
	./configure --prefix=/usr --with-config-path=/var/lib/lxc && \
	make && \
	make install)
fi
eos
  
  post_install_script = <<-eos
#!/bin/sh -e
/usr/bin/lxc-prepare-host
eos
  File.open("#{PROJECT_ROOT}/pkg/toft-lxc-pre-install.sh", 'w') { |f| f.write(pre_install_script) }
  File.open("#{PROJECT_ROOT}/pkg/toft-lxc-post-install.sh", 'w') { |f| f.write(post_install_script) }
  
  Dir.chdir("pkg") do
    system <<-EOF
    fpm -s dir \
    -t rpm \
    -C #{content_dir} \
    -a all \
    -n #{LXC_PACKAGE_NAME} \
    -v #{Toft::VERSION} \
    -m "Huang Liang<exceedhl@gmail.com>" \
    --description "lxc templates and helper provided by toft" \
    -d sudo \
    -d bind-utils \
    -d bridge-utils \
    -d dhcp \
    -d bind \
    -d ntp \
    -d libcap-devel \
    --post-install "#{PROJECT_ROOT}/pkg/toft-lxc-post-install.sh" \
    --pre-install "#{PROJECT_ROOT}/pkg/toft-lxc-pre-install.sh" \
    .
    EOF
  end
end

desc "run all tests and features"
task :test do
  `rspec spec`
  `sudo cucumber features`
end
