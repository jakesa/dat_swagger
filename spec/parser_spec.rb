require_relative 'spec_helper'
require 'pry'
include Utils
describe DAT::Swagger::Parser do

  context 'Class Methods' do
    it 'should respond to #instance' do
      expect(DAT::Swagger::Parser.respond_to? :instance).to be true
    end

    it 'should respond to #routes' do
      expect(DAT::Swagger::Parser.respond_to? :routes).to be true
    end

    it 'should respond to #models' do
      expect(DAT::Swagger::Parser.respond_to? :models).to be true
    end

    it 'should respond to #parse' do
      expect(DAT::Swagger::Parser.respond_to? :parse).to be true
    end

    it 'should instantiate an instance without raising an error ' do
      expect{DAT::Swagger::Parser.instance config: nil, model_builder: nil}.not_to raise_error
    end

  end

  context 'Instance' do

    before :all do
      @config = MockConfig.new
      @model_builder = MockModelBuilder.new
      @parser = DAT::Swagger::Parser.new config: @config
    end

    it 'should respond to #routes' do
      expect(@parser.respond_to? :routes).to be true
    end

    it 'should respond to #models' do
      expect(@parser.respond_to? :models).to be true
    end

    it 'should respond to #parse' do
      expect(@parser.respond_to? :parse).to be true
    end

  end

  context 'JSONParser Extended Class' do
    before :all do
      @config = MockConfig.new
      @model_builder = MockModelBuilder.new
      @parser = DAT::Swagger::JSONParser.new config: @config, model_builder: @model_builder
    end

    it 'should respond to #routes' do
      expect(@parser.respond_to? :routes).to be true
    end

    it 'should respond to #models' do
      expect(@parser.respond_to? :models).to be true
    end

    it 'should respond to #parse' do
      expect(@parser.respond_to? :parse).to be true
    end

    it 'should parse models a JSON file from the config object' do
      @parser.parse
      expect(@parser.models.empty?).to be false
    end

    it 'should parse routes from a JSON file from the config object' do
      @parser.parse
      expect(@parser.routes.empty?).to be false
    end

    it 'should parse a specific file' do
      parser = DAT::Swagger::JSONParser.new config: nil, model_builder: @model_builder
      parser.parse path: resolve_path('../../spec/data/resultsAPI-swagger.json')
      expect(parser.models.empty?).to be false
      expect(parser.routes.empty?).to be false
    end

  end

  context 'YAMLParser Extended Class' do
    before :all do
      @config = MockConfig.new
      @model_builder = MockModelBuilder.new
      @parser = DAT::Swagger::YAMLParser.new config: nil, model_builder: @model_builder
    end

    it 'should respond to #routes' do
      expect(@parser.respond_to? :routes).to be true
    end

    it 'should respond to #models' do
      expect(@parser.respond_to? :models).to be true
    end

    it 'should respond to #parse' do
      expect(@parser.respond_to? :parse).to be true
    end

    it 'should parse a specific file' do
      parser = DAT::Swagger::YAMLParser.new config: nil, model_builder: @model_builder
      parser.parse path: resolve_path('../../spec/data/blt_swagger.yaml')
      expect(parser.models.empty?).to be false
      expect(parser.routes.empty?).to be false
    end

  end

end