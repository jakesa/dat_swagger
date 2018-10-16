require_relative 'spec_helper'
require 'pry'

describe DAT::Swagger::Client do

  context 'Class Methods' do

    it 'should respond to #instance' do
      expect(DAT::Swagger::Client.respond_to? :instance).to be true
    end

    it 'should respond to #config' do
      expect(DAT::Swagger::Client.respond_to? :config).to be true
    end

    it 'should respond to #configure' do
      expect(DAT::Swagger::Client.respond_to? :configure).to be true
    end

    it 'should respond to #reset_config' do
      expect(DAT::Swagger::Client.respond_to? :reset_config).to be true
    end

    it 'should respond to #models' do
      expect(DAT::Swagger::Client.respond_to? :models).to be true
    end

    it 'should respond to #list_resources' do
      expect(DAT::Swagger::Client.respond_to? :list_resources).to be true
    end

    it 'should respond to #parse_file' do
      expect(DAT::Swagger::Client.respond_to? :parse_file).to be true
    end

  end

  context 'Instance' do

    before :all do
      @client = DAT::Swagger::Client.new parsers: {json: MockParser, yaml: MockParser}, file: MockConfig.new.swagger_file_path
    end

    it 'should respond to #models' do
      expect(DAT::Swagger::Client.respond_to? :models).to be true
    end

    it 'should respond to #list_resources' do
      expect(DAT::Swagger::Client.respond_to? :list_resources).to be true
    end

    it 'should respond to #parse_file' do
      expect(DAT::Swagger::Client.respond_to? :parse_file).to be true
    end



  end

end