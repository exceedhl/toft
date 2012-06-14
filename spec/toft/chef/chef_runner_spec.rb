require 'spec_helper'

describe "ChefRunner" do
  it "should throw exception if json file not exist" do
    cf = Toft::Chef::ChefRunner.new "whatever"
    lambda { cf.run "run list", :json => "non-exist-file" }.
      should raise_error Errno::ENOENT, "No such file or directory - non-exist-file"
  end

  it "should throw exception if json file syntax is illegal" do
    cf = Toft::Chef::ChefRunner.new "whatever"
    lambda { cf.run "run list", :json => "#{PROJECT_ROOT}/spec/fixtures/illegal_syntax.json" }.
      should raise_error JSON::ParserError
  end
  
  it "should throw exception if cookbook path not set" do
    cf = Toft::Chef::ChefRunner.new "whatever"
    lambda { cf.run "run list" }.should raise_error ArgumentError, "Toft.cookbook_path can not be empty!"
  end

  it "should throw exception if cookbook not exist" do
    Toft.cookbook_path = "non-exist-cookbook"
    cf = Toft::Chef::ChefRunner.new "whatever"
    lambda { cf.run "run list" }.should raise_error RuntimeError
  end

  it "should throw exception if roles not exist" do
    Toft.cookbook_path = "#{PROJECT_ROOT}/fixtures/chef/cookbookse"
    Toft.role_path = "non-exist-roles"
    cf = Toft::Chef::ChefRunner.new "#{PROJECT_ROOT}/tmp"
    lambda { cf.run "run list" }.should raise_error RuntimeError
  end

  it "should throw exception if data bags not exist" do
    Toft.cookbook_path = "#{PROJECT_ROOT}/fixtures/chef/cookbookse"
    Toft.data_bag_path = "non-exist-data-bags"
    cf = Toft::Chef::ChefRunner.new "#{PROJECT_ROOT}/tmp"
    lambda { cf.run "run list" }.should raise_error RuntimeError
  end

end
