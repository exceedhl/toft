require 'json'

module Tuft
  class ChefAttributes
    attr_reader :attributes
    
    def initialize(cuke_ast_table)
      @attributes = {}
      cuke_ast_table.hashes.each do |row|
        add_attribute row[:key], row[:value]
      end
    end
    
    def add_attribute(key, value)
      stat = "attributes"
      head = attributes
      key.split(".").each do |k|
        head[k] ||= Hash.new
        head = head[k]
        stat += "[\"#{k}\"]"
      end
      eval "#{stat}=\"#{value}\""
    end
    
    def to_json
      attributes.to_json
    end
  end
end