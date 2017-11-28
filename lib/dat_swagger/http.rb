require 'net/http'
require 'json'

module DATSwagger

  class HTTP

    def initialize(host, port, headers={})
      @host = host
      @port = port
      @http = Net::HTTP
      @headers = headers
      @url = "http://#{host}:#{port}"
    end

    #params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def get(uri, params={})
      req = @http::Get.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    #params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def post(uri, params={})
      req = @http::Post.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    #params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def put(uri, params={})
      req = @http::Put.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    #params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def patch(uri, params={})
      req = @http::Patch.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    #params
    # {
    #     headers:{},
    #     qs_params: {},
    #     body: {}
    # }
    def delete(uri, params={})
      req = @http::Delete.new(URI("#{@url}#{uri}"))
      send_request req, params
    end

    private
    def send_request(req, params)
      @headers.each do |key, value|
        req[key] = value
      end unless @headers.nil?

      params.each do |key, value|
        case key
          when :headers
            value.each do |name, _value|
              req[name] = _value
            end
          when :qs_params
            query = ''
            value.each do |name, _value|
              if query.empty?
                query << "#{name}=#{_value}"
              else
                query << "&#{name}=#{_value}"
              end
            end
            req.query = query
          when :body
            req.body = JSON.generate params[:body]
        end
      end

      http = @http.new(@host, @port)
      response = http.request(req)
      response
      {
          statusCode: response.code,
          message: response.message,
          body: (JSON.parse(response.body) unless response.code == '204' || response.body.empty?)
      }
    end


  end

end