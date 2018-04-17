require_relative 'spec_helper'
require 'pry'

describe DATSwagger do

  context('instance') do
    it 'should return an instance of the class' do
      expect(DATSwagger.new).not_to be_nil
    end

    it 'should return a config object' do
      expect(DATSwagger.new.config).not_to be_nil
    end

    it 'can be initialized with a swagger file' do
      expect(DATSwagger.new('./spec/resultsAPI-swagger.json')).not_to be_nil
    end


    before(:all) do
      @swag = DATSwagger.new
    end

    it 'should be configurable with a block' do
      config = @swag.configure do |conf|
        conf.host = 'this-is-a-test.com'
      end
      expect(config.host).to eq 'this-is-a-test.com'
    end

    it 'should add properties to the config if they do not exist' do
      config = @swag.configure do |conf|
        conf.test = 'this-is-a-test'
      end
      expect(config.test).to eq 'this-is-a-test'
    end

    it 'should respond to get' do
      expect(@swag.respond_to? :get).to be true
    end

    it 'should respond to post' do
      expect(@swag.respond_to? :post).to be true
    end

    it 'should respond to patch' do
      expect(@swag.respond_to? :patch).to be true
    end

    it 'should respond to put' do
      expect(@swag.respond_to? :put).to be true
    end

    it 'should respond to delete' do
      expect(@swag.respond_to? :get).to be true
    end

    context('Can make calls without a swagger file') do

      before :all do
        @server = Server.new
        @server.start
        @swag.config.url = 'http://localhost:4567'
      end

      after :all do
        @server.stop

      end

      it 'should make a get call' do
        expect(@swag.get('/')[:statusCode]).to eq '200'
      end

      it 'should make a post call' do
        expect(@swag.post('/', {body: {}})[:statusCode]).to eq '200'
      end

      it 'should make a patch call' do
        expect(@swag.patch('/', {body: {}})[:statusCode]).to eq '200'
      end

      it 'should make a put call' do
        expect(@swag.put('/', {body:{}})[:statusCode]).to eq '200'
      end

      it 'should make a delete call' do
        expect(@swag.delete('/1')[:statusCode]).to eq '200'
      end
    end

  end

  context('class') do
    it 'should have a config at the class level' do
      expect(DATSwagger.config).not_to be_nil
    end

    it 'should be configurable with a block' do
      config = DATSwagger.configure do |conf|
        conf.host = 'this-is-a-test.com'
      end
      expect(config.host).to eq 'this-is-a-test.com'
    end

    it 'should add properties to the config if they do not exist' do
      config = DATSwagger.configure do |conf|
        conf.test = 'this-is-a-test'
      end
      expect(config.test).to eq 'this-is-a-test'
    end

    it 'should respond to get' do
      expect(DATSwagger.respond_to? :get).to be true
    end

    it 'should respond to post' do
      expect(DATSwagger.respond_to? :post).to be true
    end

    it 'should respond to patch' do
      expect(DATSwagger.respond_to? :patch).to be true
    end

    it 'should respond to put' do
      expect(DATSwagger.respond_to? :put).to be true
    end

    it 'should respond to delete' do
      expect(DATSwagger.respond_to? :get).to be true
    end

    context('Can make calls without a swagger file') do

      before :all do

        @server = Server.new
        @server.start
        DATSwagger.configure do | config |
          config.url = 'http://localhost:4567'
        end
      end

      after :all do
        @server.stop
        DATSwagger.reset_config
      end

      it 'should make a get call' do
        expect(DATSwagger.get('/')[:statusCode]).to eq '200'
      end

      it 'should make a post call' do
        expect(DATSwagger.post('/', {body: {}})[:statusCode]).to eq '200'
      end

      it 'should make a patch call' do
        expect(DATSwagger.patch('/', {body: {}})[:statusCode]).to eq '200'
      end

      it 'should make a put call' do
        expect(DATSwagger.put('/', {body:{}})[:statusCode]).to eq '200'
      end

      it 'should make a delete call' do
        expect(DATSwagger.delete('/1')[:statusCode]).to eq '200'
      end
    end


  end




  # context('Make requests from resources defined in a swagger file') do
  #
  #   before(:all) do
  #     @swag = DATSwagger.new('./spec/resultsAPI-swagger.json')
  #   end
  #
  # end

end