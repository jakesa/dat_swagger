require 'net/http'
require 'uri'
require 'json'

module DatSwagger
  class HTTP
    def initialize(options = {})
      @host = options[:host]
      @port = options[:port]
      @http_class = Net::HTTP
      @headers = options[:headers] ? options[:headers] : {}
      @url = options[:url] ? options[:url] : "http://#{@host}:#{@port}"
      uri = URI.parse(@url)
      @http = @http_class.new(uri.host, uri.port)
      if @url.include? 'https'
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def get(uri, params = {})
      req = @http_class::Get.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def post(uri, params = {})
      req = @http_class::Post.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def put(uri, params = {})
      req = @http_class::Put.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def patch(uri, params = {})
      req = @http_class::Patch.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def delete(uri, params = {})
      req = @http_class::Delete.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    private

    def send_request(req, params)
      unless @headers.nil?
        @headers.each do |key, value|
          req[key] = value
        end
      end

      params.each do |key, value|
        case key
        when :headers
          value.each do |name, _value|
            req[name] = _value
          end
        when :qs_params
          req.query =
            value.map do |name, _value|
              query.empty? ? "#{name}=#{_value}" : "&#{name}=#{_value}"
            end.join
        when :body
          req.body = JSON.generate params[:body]
        end
      end
      response = @http.request(req)
      {
        statusCode: response.code,
        message: response.message,
        body: (JSON.parse(response.body) unless response.code == '204' || response.body.empty?)
      }
    end
  end
end