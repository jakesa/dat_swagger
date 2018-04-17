require 'net/http'
require 'uri'
require 'json'

class DATSwagger
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
      send_request build_request :get, uri, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def post(uri, params = {})
      send_request build_request :post, uri, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def put(uri, params = {})
      send_request build_request :put, uri, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def patch(uri, params = {})
      send_request build_request :patch, uri, params
    end

    # params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def delete(uri, params = {})
      send_request build_request :delete, uri, params
    end

    private

    def build_request(http_method, uri, params)
      # parse qs_params
      _uri = URI("#{@url}#{uri}")

      if params[:qs_params]
        _uri.query = URI.encode_www_form(params[:qs_params])
      end

      # generate request
      case http_method
        when :get
          req = @http_class::Get.new(_uri)
        when :post
          req = @http_class::Post.new(_uri)
        when :patch
          req = @http_class::Patch.new(_uri)
        when :put
          req = @http_class::Put.new(_uri)
        when :delete
          req = @http_class::Delete.new(_uri)
        else
          raise StandardError.new("Missing valid HTTP method. Got: #{http_method}")
      end

      # parse headers
      unless @headers.nil?
        @headers.each do |key, value|
          req[key] = value
        end
      end
      if params[:headers]
        params[:header].each do |name, _value|
          req[name] = _value
        end
      end

      # build body
      if params[:body]
        req.body = JSON.generate params[:body]
      end
      req
    end

    def send_request(req)
      response = @http.request(req)
      {
        statusCode: response.code,
        message: response.message,
        body: (JSON.parse(response.body) unless response.code == '204' || response.body.empty?)
      }
    end
  end
end