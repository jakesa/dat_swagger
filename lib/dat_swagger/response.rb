

class DATSwagger
  class Response
    attr_reader :statusCode, :message, :body, :response, :path

    def initialize(response, path)
      @statusCode = response[:statusCode]
      @response = response
      @path = path
      model = get_model response[:statusCode], path[path.keys[0]]
      @body =
        if model
          if response[:body].is_a?(Array)
            response[:body].map { |item| model.new(item) }
          else
            model.new(response[:body])
          end
        else
          response[:body]
        end
      @message = response[:message]
    end

    private

    def get_model(code, path)
      res = path['responses'][code.to_s]
      return nil if res.nil?
      return nil if res['schema'].nil?
      model = if res['schema']['items']
                res['schema']['items']['$ref']
              elsif res['schema']['$ref']
                res['schema']['$ref']
              end
      return nil if model.nil?
      mod = model.split('/').last.capitalize
      return DATSwagger::Models.const_get(mod) if DATSwagger::Models.const_defined?(mod)
      nil
    end
  end
end
