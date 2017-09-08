require 'pry'
require 'json'
require_relative 'model'
module DATSwagger

  class Config

    attr_reader :get, :post, :patch, :delete, :update, :models
    attr_accessor :host, :port, :headers, :url

    def initialize(swagger_file_path='')
      # load the swagger file
      # create the call library based on the swagger file.
      @file_path = swagger_file_path
      @get = []
      @post = []
      @patch = []
      @delete = []
      @update = []
      @models = []
      # if the file is passed in on init, load it
      load_swagger_file unless @file_path.empty?
    end

    def file_path=(path)
      @file_path = path
      load_swagger_file
    end

    def file_path
      @file_path
    end

    def load_swagger_file
      raise 'Config.file_path needs to be set to the location of your swagger.json file' if @file_path.empty?
      @file ||= File.read(File.expand_path("#{@file_path}"))
      data = JSON.parse(@file)
      data["paths"].each do |path, values|
        values.each do |_method, _values |
          case _method
            when 'get'
              @get << {path => _values}
            when 'post'
              @post << {path => _values}
            when 'patch'
              @patch << {path => _values}
            when 'delete'
              @delete << {path => _values}
            when 'update'
              @update << {path => _values}
          end
        end
      end

      build_models data['definitions']

      _host = data['host'].split(':')
      @host = _host[0] unless @host != nil
      @port = _host[1] unless @port != nil
      @url = "http://#{host}:#{port}" unless @url != nil
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
            args[0]['properties'].each do |name, props|
              attr_accessor name
              @fields << name
              @field_definitions[name] = props
            end unless args[0].nil? || args[0]['properties'].nil?
            args[0]['required'].each do |arg|
              @required_fields << arg
            end unless args[0].nil? || args[0]['required'].nil?
          end

          def self.fields
            @fields
          end

          def self.required_fields
            @required_fields
          end

          def self.field_definitions
            @field_definitions
          end

          def initialize(data_hash={})
            data_hash.each do |field, value|
              send("#{field.to_s}=", value) if self.respond_to? "#{field.to_s}="
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
          def list_hash(hash, index=0)
            hash.each_key do |key|
              key_space = index > 0 ? ' '*index : ''
              value_space = key_space + '  '
              puts "#{key_space}#{key}:"
              value = hash[key]
              if value.is_a? Hash
                list_hash value, index +=1
              elsif value.is_a? Array
                value.each do |value|
                  if value.is_a? Hash
                    list_hash value, index +=1
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

        DATSwagger::Models.const_set(name.capitalize, model) unless DATSwagger::Models.const_defined?(name.capitalize)
        name = name.capitalize
        @models << name
        DATSwagger::Models.const_get(name).send(:add_fields, properties)
      end
    end


    def method_missing(name, *args, &block)
      value = args[0]
      if name.match(/^.*=/) != nil
        unless respond_to?(name) || respond_to?("#{name.to_s.gsub('=','')}".to_sym)
          define_singleton_method(name) {|val|instance_variable_set("@#{name.to_s.gsub('=','')}", val)}
          define_singleton_method("#{name.to_s.gsub('=','')}") {instance_variable_get("@#{name.to_s.gsub('=','')}")}
          self.send(name, value)
        end
      else
        nil
      end
    end
  end

end