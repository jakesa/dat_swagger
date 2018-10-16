require_relative 'spec_helper'
require 'pry'
include Utils

describe DAT::Swagger::ModelBuilder do

  context 'Class Methods' do
    it 'should respond to #build' do
      expect(DAT::Swagger::ModelBuilder.respond_to? :build).to be true
    end

    it 'should respond to #set_model' do
      expect(DAT::Swagger::ModelBuilder.respond_to? :set_model).to be true
    end

    it 'should respond to #define_model' do
      expect(DAT::Swagger::ModelBuilder.respond_to? :define_model).to be true
    end

    it 'should set the model' do
      DAT::Swagger::ModelBuilder.set_model name: 'NewModel', obj: Class.new(MockModel)
      expect(DAT::Swagger.const_defined? 'NewModel').to be true
    end

    it 'should not set the model if the model is already defined' do
      DAT::Swagger::ModelBuilder.set_model name: 'NewModel', obj: Class.new(MockModel)
      DAT::Swagger::ModelBuilder.set_model name: 'NewModel', obj: Class.new(MockModel2)
      expect(DAT::Swagger::NewModel.respond_to? :model).to be false
    end

    it 'should define a model' do
      DAT::Swagger::ModelBuilder.set_model name: 'NewModel', obj: Class.new(MockModel)
      DAT::Swagger::ModelBuilder.define_model name: 'NewModel', methods: { random_method: {number: 1}}
      expect(DAT::Swagger::NewModel.number).to eq 1
    end


  end

end