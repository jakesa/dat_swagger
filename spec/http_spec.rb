require_relative 'spec_helper'
require_relative 'stub_server'
require 'pry'
describe DATSwagger::HTTP do

  it 'should respond to #put' do
    http = DATSwagger::HTTP.new {}
    expect(http.respond_to? :put).to be true
  end

  it 'should respond to #post' do
    http = DATSwagger::HTTP.new {}
    expect(http.respond_to? :post).to be true
  end

  it 'should respond to #patch' do
    http = DATSwagger::HTTP.new {}
    expect(http.respond_to? :patch).to be true
  end

  it 'should respond to #get' do
    http = DATSwagger::HTTP.new {}
    expect(http.respond_to? :get).to be true
  end

  it 'should respond to #delete' do
    http = DATSwagger::HTTP.new {}
    expect(http.respond_to? :delete).to be true
  end

  it 'can be initialized with a url string' do
    expect(DATSwagger::HTTP.new({url: 'http://localhost:4567'})).not_to be_nil
  end


  describe 'requests/responses' do

    before :all do

      @server = Server.new
      @server.start
      @http = DATSwagger::HTTP.new({host: 'localhost', port: '4567'})
    end

    after :all do
      @server.stop
    end

    context('get') do
      it 'should be able to send a get request' do
        res = @http.get('/')
        expect(res[:statusCode]).to eq '200'
      end

      it 'should handle qs_params' do
        res = @http.get('/', {qs_params: {test: 1}})
        expect(res[:body]['params']['test']).to eq '1'
      end

      it 'can accept multiple qs_params' do
        res = @http.get('/', {qs_params: {test: 1, test2: 2}})
        expect(res[:body]['params']['test']).to eq '1'
        expect(res[:body]['params']['test2']).to eq '2'
      end

    end

    context('put') do
      it 'should be able to send a put request' do
        res = @http.put('/',{body:{}})
        expect(res[:statusCode]).to eq '200'
      end

      it 'should handle a payload' do
        res = @http.put('/', {
            body: JSON.generate({test:'data'})
        })
        expect(res[:statusCode]).to eq '200'
        expect(JSON.parse(res[:body]['payload'])['test']).to eq 'data'
      end

    end

    context('post') do
      it 'should be able to send a post request' do
        res = @http.post('/',{body:{}})
        expect(res[:statusCode]).to eq '200'
      end

      it 'should handle a payload' do
        res = @http.post('/', {
            body: JSON.generate({test:'data'})
        })
        expect(res[:statusCode]).to eq '200'
        expect(JSON.parse(res[:body]['payload'])['test']).to eq 'data'
      end
    end

    context('patch') do
      it 'should be able to send a patch request' do
        res = @http.patch('/',{body:{}})
        expect(res[:statusCode]).to eq '200'
      end

      it 'should handle a payload' do
        res = @http.patch('/', {
            body: JSON.generate({test:'data'})
        })
        expect(res[:statusCode]).to eq '200'
        expect(JSON.parse(res[:body]['payload'])['test']).to eq 'data'
      end
    end

    context('delete') do
      it 'should be able to send a delete request' do
        res = @http.delete('/1')
        expect(res[:statusCode]).to eq '200'
      end

      it 'should delete a specific id' do
        res = @http.delete('/1')
        expect(res[:statusCode]).to eq '200'
        expect(JSON.parse(res[:body]['id'])).to eq 1
      end
    end

    # JS: mocking ssl on the sinatra server is more work than I want to get into at the moment. Will revisit this later
    # context('https') do
    #   it 'can handle https calls' do
    #     http = DATSwagger::HTTP.new({url: 'https://localhost:4567'})
    #     expect(http.get('/')[:statusCode]).to eq '200'
    #   end
    # end


  end


  end