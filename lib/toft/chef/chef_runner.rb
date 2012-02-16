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

      def run(run_list, params = {})
        override_attributes_hash = parse_attributes params[:json], params[:attributes] 
        copy_chef_material
        generate_solo_rb
        generate_json ([] << run_list).flatten, override_attributes_hash
        @command_runner.call "chef-solo -c #{DEST_CHEF_SOLO_PATH} -j #{DEST_CHEF_JSON_PATH}"
      end

      private 
      def parse_attributes(json_file_path, chef_attributes)
        chef_attributes = chef_attributes || ChefAttributes.new
        chef_attributes_from_json ||= {}
        chef_attributes_from_json = read_json_file json_file_path unless json_file_path.blank?
        chef_attributes_from_json.merge chef_attributes.attributes
      end
      
      def read_json_file(json_file_path)
        JSON.parse(File.read(json_file_path))
      end
    
      def copy_chef_material
        raise ArgumentError, "Toft.cookbook_path can not be empty!" if Toft.cookbook_path.blank?
        rm_rf "#{@root_dir}#{DEST_CHEF_TMP}"  
        mkdir_p "#{@root_dir}#{DEST_CHEF_TMP}"
        cp_r Toft.cookbook_path, "#{@root_dir}#{DEST_COOKBOOK_PATH}"
        cp_r Toft.role_path, "#{@root_dir}#{DEST_ROLE_PATH}" unless roles_missing?
      end

      def roles_missing?
        Toft.role_path.blank?
      end

      def generate_solo_rb
        mkdir_p "#{@root_dir}/tmp/chef-file-cache"
        solo = <<-EOF
file_cache_path "/tmp/chef-file-cache"
cookbook_path ["#{DEST_COOKBOOK_PATH}"]
        EOF
        solo += "role_path [\"#{DEST_ROLE_PATH}\"]" unless roles_missing?

        File.open("#{@root_dir}#{DEST_CHEF_SOLO_PATH}", 'w') do |f|
          f.write(solo);
        end
      end

      def generate_json(run_list, override_attributes_hash)
        run_list = {"run_list" => run_list}
        run_list.merge!(override_attributes_hash)
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