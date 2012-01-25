$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rspec/expectations'
require 'toft'

CHEF_FIXTURE_PATH = File.dirname(__FILE__) + '/../../fixtures/chef'
PUPPET_FIXTURE_PATH = File.dirname(__FILE__) + '/../../fixtures/puppet'

CONTAINER_TYPE = "natty"

World(Toft)

include Toft
n1 = create_node "n1", {:ip => "192.168.20.2", :type => CONTAINER_TYPE}

Before do
  Toft.cookbook_path = CHEF_FIXTURE_PATH + '/cookbooks'
  Toft.role_path = CHEF_FIXTURE_PATH + '/roles'

  Toft.manifest_path = PUPPET_FIXTURE_PATH + '/manifests'

  @n1 = n1
end

at_exit do
  n1.destroy
end
