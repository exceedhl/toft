require 'toft/chef/chef_attributes'
require 'fileutils'

module Toft
  module Chef
    class ChefRunner
      include FileUtils
      
      DEST_CHEF_TMP = "/tmp/toft-chef-tmp"
      DEST_COOKBOOK_PATH = "#{DEST_CHEF_TMP}/cookbooks"
      DEST_ROLE_PATH = "#{DEST_CHEF_TMP}/roles"
      DEST_CHEF_SOLO_PATH = "#{DEST_CHEF_TMP}/solo.rb" 
      DEST_CHEF_JSON_PATH = "#{DEST_CHEF_TMP}/solo.json" 

      def initialize(root_dir, &command_runner)
        @root_dir = root_dir
        @command_runner = command_runner
      end

      def run(run_list, chef_attributes)
        copy_chef_material
        generate_solo_rb
        generate_json ([] << run_list).flatten, chef_attributes
        @command_runner.call "chef-solo -c #{DEST_CHEF_SOLO_PATH} -j #{DEST_CHEF_JSON_PATH}"
      end

      private 
      def copy_chef_material
        rm_rf "#{@root_dir}#{DEST_CHEF_TMP}"  
        mkdir_p "#{@root_dir}#{DEST_CHEF_TMP}"
        cp_r Toft.cookbook_path, "#{@root_dir}#{DEST_COOKBOOK_PATH}"
        cp_r Toft.role_path, "#{@root_dir}#{DEST_ROLE_PATH}" unless roles_missing?
      end

      def roles_missing?
        Toft.role_path.blank?
      end

      def generate_solo_rb
        solo = <<-EOF
file_cache_path "/tmp/chef-file-cache"
cookbook_path ["#{DEST_COOKBOOK_PATH}"]
        EOF
        solo += "role_path [\"#{DEST_ROLE_PATH}\"]" unless roles_missing?

        File.open("#{@root_dir}#{DEST_CHEF_SOLO_PATH}", 'w') do |f|
          f.write(solo);
        end
      end

      def generate_json(run_list, chef_attributes)
        run_list = {"run_list" => run_list}
        run_list.merge!(chef_attributes.attributes) unless chef_attributes.nil?
        File.open("#{@root_dir}#{DEST_CHEF_JSON_PATH}", 'w') do |f|
          f.write(run_list.to_json);
        end
      end

      def cmd(cmd)
        raise "Command execution failed: [#{cmd}]" unless system cmd
      end
    end
  end
end