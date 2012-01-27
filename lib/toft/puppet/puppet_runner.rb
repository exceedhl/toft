require 'fileutils'

module Toft
  module Puppet 
    class PuppetRunner
      include FileUtils
      
      DEST_PUPPET_TMP = "/tmp/toft-puppet-tmp"
      DEST_MANIFEST_PATH = "#{DEST_PUPPET_TMP}/manifests"

      def initialize(root_dir, &command_runner)
        @root_dir = root_dir
        @command_runner = command_runner
      end

      def run(run_list, params = {})
        copy_puppet_material
        @command_runner.call "puppet apply #{DEST_MANIFEST_PATH}/#{run_list}"
      end

      private 
    
      def copy_puppet_material
        raise ArgumentError, "Toft.manifest_path can not be empty!" if Toft.manifest_path.blank?
        rm_rf "#{@root_dir}#{DEST_PUPPET_TMP}"  
        mkdir_p "#{@root_dir}#{DEST_PUPPET_TMP}"
        cp_r Toft.manifest_path, "#{@root_dir}#{DEST_MANIFEST_PATH}"
      end

    end
  end
end
