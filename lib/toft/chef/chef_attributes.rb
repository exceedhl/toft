require 'json'

module Toft
  class ChefAttributes
    attr_reader :attributes
    
    def initialize(cuke_ast_table = nil)
      @attributes = {}
      cuke_ast_table.hashes.each do |row|
        add_attribute row[:key], row[:value]
      end unless cuke_ast_table.nil?
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