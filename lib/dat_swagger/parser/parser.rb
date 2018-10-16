require_relative '../model/model_builder'
module DAT::Swagger

  class Parser
    attr_reader :attrs

    class << self
      def instance(config: DAT::Swagger::Client.config, model_builder: DAT::Swagger::ModelBuilder)
        @instance ||= new config: config, model_builder: model_builder
      end

      def routes(method:)
        instance.routes method: method
      end

      def models
        instance.models
      end

      def parse(path: DAT::Swagger::Client.config.swagger_file_path)
        instance.parse path: path
      end

    end

    def initialize(config: DAT::Swagger::Client.config, model_builder: DAT::Swagger::ModelBuilder)
      @config = config
      @model_builder = model_builder
    end


    def routes(method: nil)
      if method.nil?
        @routes.dup
      else
        @routes[method.to_sym]
      end
    end

    def models
      @models.dup
    end

    def parse(path: DAT::Swagger::Client.config.swagger_file_path)
      data = load_file path: path
      generate_routes routes: data[:paths]
      generate_models definitions: data[:definitions]
      generate_meta_data data: data
      self
    end


    def method_missing(name, *args, &block)
      value = args[0]
      if name.match(/^.*=/) != nil
        unless respond_to?(name) || respond_to?("#{name.to_s.gsub('=','')}".to_sym)
          self.class.attr_accessor name.to_s.gsub('=','').to_sym
          @attrs << name.to_s.gsub('=','').to_sym
          send(name, value)
        end
      else
        super
      end
    end

    private

    def generate_routes(routes: )
      @routes = {
          get: [],
          post: [],
          patch: [],
          delete: [],
          put: []
      }
      routes.each do |path, values|
        values.each do |_method, _values|
          @routes[_method.to_sym] << { path: path, attrs: _values } unless @routes[_method.to_sym].nil?
        end
      end
    end

    def generate_models(definitions:)
      @models = @model_builder.build definitions: definitions
    end

    def generate_meta_data(data:)
      data.each do |name, value|
        unless name == :paths || name == :definitions
          if value.is_a? Hash
            generate_meta_data data: value
          else
            load_data data: {name.to_sym => value}
          end
        end
      end
    end

    def request_url
      if @basePath.nil?
        "#{@host}"
      else
        "#{@host}/#{@basePath}"
      end

    end

    def load_file(path:)
      raise MethodNotImplemented, 'Method #load_file needs to be implemented'
    end

    def load_data(data: self.class.defaults)
      @attrs ||= []
      data.each do |field, value|
        send("#{field}=", value)
        @attrs << field
      end
      @attrs.uniq!
    end

  end

  class MethodNotImplemented < RuntimeError
  end

end