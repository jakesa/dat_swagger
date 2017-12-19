

module DatSwagger

  class Response

    attr_reader :statusCode, :message, :body, :response, :path

    def initialize(response, path)
      @statusCode = response[:statusCode]
      @response = response
      @path = path
      model = get_model response[:statusCode], path[path.keys[0]]
      if model
        if response[:body].is_a? Array
          items = []
          response[:body].each do |item|
            items << model.new(item)
          end
          @body = items
        else
          @body = model.new(response[:body])
        end
      else
        @body = response[:body]
      end
      @message = response[:message]
    end

    private

    def get_model(code, path)
      model = nil
      res = path['responses'][code.to_s]
      if res.nil?
        return nil
      else
        if res['schema'].nil?
          return nil
        else
          if res['schema']['items']
            model = res['schema']['items']['$ref']
          elsif res['schema']['$ref']
            model = res['schema']['$ref']
          else
            return nil
          end
        end
      end
      if model.nil?
        return nil
      else
        mod = model.split('/').last.capitalize
        if DatSwagger::Models.const_defined? mod
          return DatSwagger::Models.const_get mod
        else
          return nil
        end
      end
    end
  end

end