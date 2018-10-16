require_relative 'parser'
require 'json'

module DAT::Swagger
  class JSONParser < Parser
    def load_file(path:)
      raise 'Swagger file path was either not set or passed in' if path.nil? || path.empty?
      JSON.parse(File.read(File.expand_path(path.to_s)), symbolize_names: true)
    end
  end

end