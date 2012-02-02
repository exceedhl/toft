require 'fileutils'

module Toft
  module Puppet 
    class PuppetRunner
      include FileUtils
      
      DEST_PUPPET_TMP = "/tmp/toft-puppet-tmp"
      DEST_CONF_PATH = "/etc/puppet/puppet.conf"

      def initialize(root_dir, &command_runner)
        @root_dir = root_dir
        @command_runner = command_runner
      end

      def run(run_list, params = {})
        copy_puppet_material
        copy_conf_file(params[:conf_file]) if params[:conf_file]
        @command_runner.call "puppet apply #{DEST_PUPPET_TMP}/manifests/#{run_list}"
      end

      private 

      def copy_conf_file(conf_file)
        cp "#{@root_dir}#{DEST_PUPPET_TMP}/conf/#{conf_file}", "#{@root_dir}#{DEST_CONF_PATH}"
      end
    
      def copy_puppet_material
        raise ArgumentError, "Toft.manifest_path can not be empty!" if Toft.manifest_path.blank?
        rm_rf "#{@root_dir}#{DEST_PUPPET_TMP}"  
        mkdir_p "#{@root_dir}#{DEST_PUPPET_TMP}"

        cp_r "#{Toft.manifest_path}/.", "#{@root_dir}#{DEST_PUPPET_TMP}"
      end

    end
  end
end
