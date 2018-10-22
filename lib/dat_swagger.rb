require_relative '../lib/dat_swagger/parser/json'
require_relative '../lib/dat_swagger/parser/yaml'
require_relative 'dat_swagger/config/config'

module DAT::Swagger
  class Client

    class << self

      def instance(path: Client.config.swagger_file_path, parsers: {json: DAT::Swagger::JSONParser, yaml: DAT::Swagger::YAMLParser})
        @instance ||= new file: path, parsers: parsers
      end

      def configure
        @config ||= DAT::Swagger::Config.new
        yield(@config) if block_given?
        @config
      end

      # get the instance of the config object
      def config
        @config ||= DAT::Swagger::Config.new
      end

      # reset the config object
      def reset_config
        @config = DAT::Swagger::Config.new
      end

      def models
        instance.models
      end

      def list_resources
        instance.list_resources
      end

      def parse_file(path:)
        instance.parse_file path: path
      end

    end

    attr_reader :parsed_swagger
    def initialize(
                    file: Client.config.swagger_file_path,
                    parsers: {json: DAT::Swagger::JSONParser, yaml: DAT::Swagger::YAMLParser})
      @file = file
      @parser = parsers
      parse_file path: file unless file.nil?
    end

    def models
      check_swagger
      @parsed_swagger.models.dup
    end

    def list_resources
      check_swagger
      list_paths
    end

    def routes
      check_swagger
      parsed_swagger.routes
    end

    def parse_file(path: @file)
      raise ArgumentError, 'Swagger file path has not been set or passed in.' if path.nil?
      if path.include? '.json'
        return @parsed_swagger = @parser[:json].parse(path: path)
      elsif path.include?('.yaml') || file.include?('.yml')
        return @parsed_swagger = @parser[:yaml].parse(path: path)
      else
        raise ArgumentError, "#{file} is not a valid file format."
      end
    end

    private

    def check_swagger
      raise RuntimeError, 'No Swagger file has been parsed yet' if @parsed_swagger.nil?
    end

    # list out all the available paths
    def list_paths(method: nil)
      if method.nil?
        list_hash @parsed_swagger.routes
      else
        list_hash @parsed_swagger.routes[method]
      end
      nil
    end

    # pretty output for the contents of a hash
    def list_hash(hash, index = 0)
      hash.each_key do |key|
        key_space = index > 0 ? ' ' * index : ''
        value_space = key_space + '  '
        puts "#{key_space}#{key}:"
        value = hash[key]
        if value.is_a? Hash
          list_hash value, index += 1
        elsif value.is_a? Array
          value.each do |value|
            if value.is_a? Hash
              list_hash value, index += 1
            else
              puts "#{value_space}#{value}"
            end
          end
        else
          puts "#{value_space}#{value}"
        end
      end
    end
  end
end
