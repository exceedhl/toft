require 'spec_helper'

describe "PuppetRunner" do

  it "should run puppet apply to manifest" do
    Toft.manifest_path = "#{PROJECT_ROOT}/fixtures/puppet/manifests"
    runner = Toft::Puppet::PuppetRunner.new("whatever") do |command|
      command.include?("puppet apply").should be_true
    end    
    lambda { runner.run "test" }.should_not raise_error
  end
  
end
