require_relative 'spec_helper'
require_relative 'stub_server'
require 'pry'
describe DatSwagger::HTTP do

  it 'should respond to #put' do
    http = DatSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :put).to be true
  end

  it 'should respond to #post' do
    http = DatSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :post).to be true
  end

  it 'should respond to #patch' do
    http = DatSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :patch).to be true
  end

  it 'should respond to #get' do
    http = DatSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :get).to be true
  end

  it 'should respond to #delete' do
    http = DatSwagger::HTTP.new '', '', {}
    expect(http.respond_to? :delete).to be true
  end
  describe 'requests/responses' do

    before :all do
      @server = Server.new
      @server.start
      @http = DatSwagger::HTTP.new('localhost', '4567')
    end

    after :all do
      @server.stop
    end

    it 'should be able to send a put request' do

    end

  end
end