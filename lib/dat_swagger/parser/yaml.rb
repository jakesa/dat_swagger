require_relative 'parser'
require 'yaml'
require 'json'
require 'pry'

module DAT::Swagger

  class YAMLParser < Parser
    def load_file(path:)
      raise 'Swagger file path was either not set or passed in' if path.nil? || path.empty?
      JSON.parse( JSON.generate(YAML.load_file(path)), symbolize_names: true)
    end
  end

end