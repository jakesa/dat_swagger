require_relative 'spec_helper'
require_relative 'stub_server'
require 'pry'
describe DATSwagger::HTTP do

  it 'should respond to #put' do
    http = DATSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :put).to be true
  end

  it 'should respond to #post' do
    http = DATSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :post).to be true
  end

  it 'should respond to #patch' do
    http = DATSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :patch).to be true
  end

  it 'should respond to #get' do
    http = DATSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :get).to be true
  end

  it 'should respond to #delete' do
    http = DATSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :delete).to be true
  end
  describe 'requests/responses' do

    before :all do
      @server = Server.new
      @server.start
      @http = DATSwagger::HTTP.new('localhost', '4567')
    end

    after :all do
      @server.stop
    end

    it 'should be able to send a put request' do

    end

  end
end