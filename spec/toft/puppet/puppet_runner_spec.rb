require 'spec_helper'

describe "PuppetRunner" do

  it "should run puppet apply to manifest" do
    Toft.manifest_path = "#{PROJECT_ROOT}/fixtures/puppet/manifests"
    runner = Toft::Puppet::PuppetRunner.new("whatever") do |command|
      command.include?("puppet apply").should be_true
    end    
    lambda { runner.run "test" }.should_not raise_error
  end

  it "should throw exception if manifest path not set" do
    Toft.manifest_path = ""
    runner = Toft::Puppet::PuppetRunner.new "whatever"
    lambda { runner.run "test" }.should raise_error ArgumentError, "Toft.manifest_path can not be empty!"
  end


  it "should throw exception if cookbook not exist" do
    Toft.manifest_path = "non-exist-manifest"
    cf = Toft::Puppet::PuppetRunner.new "whatever"
    lambda { cf.run "test" }.should raise_error RuntimeError
  end
  
end
