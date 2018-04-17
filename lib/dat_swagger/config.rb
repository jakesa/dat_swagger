require 'pry'
require 'json'
require_relative 'model'
class DATSwagger
  class Config
    attr_reader :get, :post, :patch, :delete, :models, :put
    attr_accessor :host, :port, :headers, :url

    def initialize(swagger_file_path = '')
      # load the swagger file
      # create the call library based on the swagger file.
      @file_path = swagger_file_path
      @put = []
      @get = []
      @post = []
      @patch = []
      @delete = []
      @models = []
      @swagger_file_loaded = false
      # if the file is passed in on init, load it
      load_swagger_file unless @file_path.empty?
    end

    # This needs to happen after @url @port @host are set.
    # TODO: The above sentence should be documented
    def file_path=(path)
      @file_path = path
      load_swagger_file
    end

    attr_reader :file_path

    def load_swagger_file
      raise 'Config.file_path needs to be set to the location of your swagger.json file' if @file_path.empty?
      @file ||= File.read(File.expand_path(@file_path.to_s))
      data = JSON.parse(@file)
      data['paths'].each do |path, values|
        values.each do |_method, _values|
          case _method
          when 'get'
            @get << { path => _values }
          when 'post'
            @post << { path => _values }
          when 'patch'
            @patch << { path => _values }
          when 'delete'
            @delete << { path => _values }
          when 'put'
            @put << { path => _values }
          end
        end
      end

      build_models data['definitions']
      _host = data['host'].split(':')
      @host = _host[0] if @host.nil?
      @port = _host[1] if @port.nil?
      @url = "http://#{host}:#{port}" if @url.nil?
      @swagger_file_loaded = true
    end

    def swagger_file_loaded?
      @swagger_file_loaded
    end

    def build_models(definitions)
      return false if definitions.nil? || definitions.empty?

      definitions.each do |name, properties|
        # TODO: This class needs a little work for providing useful methods for data
        model = Class.new(Object) do
          def self.add_fields(*args)
            @fields ||= []
            @required_fields ||= []
            @field_definitions ||= {}
            unless args[0].nil? || args[0]['properties'].nil?
              args[0]['properties'].each do |name, props|
                attr_accessor name
                @fields << name
                @field_definitions[name] = props
              end
            end
            unless args[0].nil? || args[0]['required'].nil?
              args[0]['required'].each do |arg|
                @required_fields << arg
              end
            end
          end

          class << self
            attr_reader :fields
            attr_reader :required_fields
            attr_reader :field_definitions
          end

          def initialize(data_hash = {})
            data_hash.each do |field, value|
              send("#{field}=", value) if respond_to? "#{field}="
            end
          end

          def list_field_definition(name)
            if field_definitions.include? name.to_s
              list_hash field_definitions[name.to_s]
            end
            ''
          end

          def field_definition(name)
            if field_definitions.include? name.to_s
              return field_definitions[name.to_s]
            end
            nil
          end

          def fields
            @fields ||= self.class.fields
          end

          def required_fields
            @required_fields ||= self.class.required_fields
          end

          def field_definitions
            @field_definitions ||= self.class.field_definitions
          end

                  private

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
        # make sure that the first letter in the class name is caps without changing the other letters
        name = name.slice(0,1).capitalize + name.slice(1..-1)
        DATSwagger::Models.const_set(name, model) unless DATSwagger::Models.const_defined?(name)
        @models << name
        DATSwagger::Models.const_get(name).send(:add_fields, properties)
      end
    end

    def method_missing(name, *args)
      value = args[0]
      return nil unless /^.*=/.match?(name)
      return nil if (respond_to?(name) || respond_to?(name.to_s.delete('=')))
      name = name.to_s.delete('=')
      define_singleton_method(name + '=') do |val|
        instance_variable_set("@#{name}", val)
      end
      define_singleton_method(name) do
        instance_variable_get("@#{name}")
      end
      self.send(name + '=', value)
    end
  end
end
