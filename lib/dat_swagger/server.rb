require_relative '../../lib/dat_swagger'
require 'sinatra'
require 'json'

get '/' do
  status '200'
  headers \
    'Content-type'=> 'application/json'
  body JSON.generate({:message => 'success'})
end

class DatSwagger::Server

  def self.build
    @server ||= self.new
  end


  def initialize
    check_config
    build_server
  end

  private

  def check_config

  end

  def build_server
    [:post, :put, :patch, :get, :delete].each do |m|
      DatSwagger.config.send(m).each do |path_key, path_props|
        case m
          when :get
            get path_key.to_s do
              status '200'
              headers \
                'Content-type' => 'application/json'
              body
            end
        end
      end
    end
  end


end