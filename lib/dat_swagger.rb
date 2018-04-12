require_relative 'dat_swagger/config_object'
require_relative 'dat_swagger/http'
require_relative 'dat_swagger/response'
module DatSwagger
  # configure the config object
  # Example:
  #
  # TrackerAPI.configure do |config|
  #   config.file_path = 'swagger.json'
  # end
  def self.configure
    @config ||= DatSwagger::Config.new
    yield(@config) if block_given?
    @config
  end

  # get the instance of the config object
  def self.config
    @config ||= DatSwagger::Config.new
  end

  # reset the config object
  def self.reset_config
    @config = DatSwagger::Config.new
  end

  # get or start the http instance for making calls
  def self.http
    options = %i[url host port headers]
    @http ||= DatSwagger::HTTP.new \
      options.zip(options.map { |e| @config.send(e) }).to_h
  end

  # make a get call
  # params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.get(resource = 'options', params = {})
    process_call(:get, resource, params)
  end

  # make a post call
  # params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.post(resource = 'options', params = {})
    process_call(:post, resource, params)
  end

  # make a patch call
  # params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.patch(resource = 'options', params = {})
    process_call(:patch, resource, params)
  end

  # make a put call
  # params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.put(resource = 'options', params = {})
    process_call(:put, resource, params)
  end

  # make a delete call
  # params
  # {
  #     headers:{},
  #     qs_params: {},
  #     body: {}
  # }
  def self.delete(resource = 'options', params = {})
    process_call(:delete, resource, params)
  end

  private

  # list out all the available paths
  def self.list_paths(paths)
    paths.each do |path|
      path.each do |name, _opts|
        puts name
      end
    end
  end

  # pretty output for the contents of a hash
  def self.list_hash(hash, index = 0)
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

  # get the paths associated with the provided http method
  def self.get_path(http_method, path)
    config.send(http_method).each do |_path|
      return _path if _path.keys[0] == path
    end
    nil
  end

  # process and make the http call
  def self.process_call(http_method, resource, params = {})
    if resource == 'options'
      puts 'Here are the available options'
      list_paths(@config.send(http_method))
      return nil
    end
    path = get_path(http_method.to_sym, resource)
    if path.nil?
      raise "#{resource} is not a valid get resource. Call #get to see a "\
        'list of available paths'
    end
    if resource.include?('{')
      resource_params = resource.scan(/{\w+}/)
      resource_params.each do |param|
        _param = param.delete('{')
        _param.delete!('}')
        if params[_param.to_sym]
          resource.gsub!(param, params[_param.to_sym])
        elsif params[_param]
          resource.gsub!(param, params[_param])
        else
          raise "#{resource} includes resource parameters but none were passed"\
            ' in.'
        end
      end
    end
    if params.is_a?(String) && params.casecmp('help').zero?
      list_hash(path)
      true
    else
      # make the call
      Response.new http.send(http_method, resource, params), path
    end
  end
end