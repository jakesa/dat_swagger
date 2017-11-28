require_relative 'lib/config'
require_relative 'lib/http'
require_relative 'lib/response'
module DATSwagger

  # configure the config object
  # Example:
  #
  # TrackerAPI.configure do |config|
  #   config.file_path = 'swagger.json'
  # end
  def self.configure
    @config ||= DATSwagger::Config.new
    yield(@config) if block_given?
    @config
  end

  # get the instance of the config object
  def self.config
    @config ||= DATSwagger::Config.new
  end

  # resest the config object
  def self.reset_config
    @config = DATSwagger::Config.new
  end

  # get or start the http instance for making calls
  def self.http
    raise "DATSwagger::Config.host or DATSwagger::Config.port not yet set" if @config.host.nil? || @config.port.nil?
    @http ||= DATSwagger::HTTP.new(@config.host, @config.port, @config.headers)
  end

  # make a get call
  #params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.get(resource='options', params={})
    process_call(:get, resource, params)
  end

  # make a post call
  #params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.post(resource='options', params={})
    process_call(:post, resource, params)
  end

  # make a patch call
  #params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.patch(resource='options', params={})
    process_call(:patch, resource, params)
  end

  # make a put call
  #params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.put(resource='options', params={})
    process_call(:put, resource, params)
  end

  # make a delete call
  #params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.delete(resource='options', params={})
    process_call(:delete, resource, params)
  end

  private
  # list out all the available paths
  def self.list_paths(paths)
    paths.each do |path|
      path.each do |name, opts|
        puts name
      end
    end
  end

  # pretty output for the contents of a hash
  def self.list_hash(hash, index=0)
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

  # get the paths associated with the provided http method
  def self.get_path(http_method, path)
    @config.send(http_method).each do |_path|
      if _path.keys[0] == path
        return _path
      end
    end
    nil
  end

  # process and make the http call
  def self.process_call(http_method, resource, params={})
    if resource == 'options'
      puts 'Here are the available options'
      list_paths(@config.send(http_method))
      nil
    else
      path = get_path(http_method.to_sym, resource)
      if path.nil?
        raise "#{resource} is not a valid get resource. Call #get to see a list of available paths"
      else
        if resource.include?('{')
          resource_params = resource.scan(/{\w+}/)
          resource_params.each do |param|
            _param = param.gsub('{', '')
            _param = _param.gsub!('}', '')
            if params[_param.to_sym]
              resource.gsub!(param, params[_param.to_sym])
            elsif params[_param]
              resource.gsub!(param, params[_param])
            else
              raise "#{resource} includes resource parameters but none were passed in."
            end
          end
        end

        if params.is_a?(String) && params.downcase == 'help'
          list_hash(path)
          true
        else
          #make the call
          Response.new http.send(http_method, resource, params), path
        end
      end
    end
  end
end