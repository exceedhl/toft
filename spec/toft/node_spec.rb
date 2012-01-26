require 'spec_helper'

describe "Node" do

  describe 'run_puppet' do

    it 'should run block with puppet runner' do
      puppet_runner = mock Toft::Puppet::PuppetRunner.class
      puppet_runner.should_receive(:run).with('manifest')
      
      node = Toft::Node.new("my_host", {:runner => puppet_runner})
      node.run_puppet('manifest')

    end

  end

end
