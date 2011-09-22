require 'spec_helper'
require 'cucumber/ast/table'

describe "ChefAttributes" do
  it "should parse chef dot connected attributes" do
    ca = Tuft::ChefAttributes.new(Cucumber::Ast::Table.new([[]]))
    ca.add_attribute "one.two.three", "some"
    ca.add_attribute "one.four", "another"
    ca.attributes["one"]["two"]["three"].should == "some"
    ca.attributes["one"]["four"].should == "another"
  end
  
  it "should parse cucumber chef attributes ast table" do
    table = Cucumber::Ast::Table.new([
              ["key", "value"],
              ["one.four", "one"],
              ["one.two.three", "some"]
            ])
    ca = Tuft::ChefAttributes.new(table)
    ca.attributes["one"]["four"].should == "one"
    ca.attributes["one"]["two"]["three"].should == "some"
  end
  
  it "should return json" do
    table = Cucumber::Ast::Table.new([
              ["key", "value"],
              ["one.four", "one"],
              ["one.two.three", "some"]
            ])
    ca = Tuft::ChefAttributes.new(table)
    ca.to_json.should == "{\"one\":{\"two\":{\"three\":\"some\"},\"four\":\"one\"}}"
  end
end