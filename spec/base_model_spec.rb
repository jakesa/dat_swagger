require_relative 'spec_helper'

describe DAT::Swagger::BaseModel do

  context 'Class Methods' do

    it 'should respond to #set_required_fields' do
      expect(DAT::Swagger::BaseModel.respond_to? :set_required_fields).to eq true
    end

    it 'should respond to #set_description' do
      expect(DAT::Swagger::BaseModel.respond_to? :set_description).to eq true
    end

    it 'should respond to #description' do
      expect(DAT::Swagger::BaseModel.respond_to? :description).to eq true
    end

    it 'should respond to #required_fields' do
      expect(DAT::Swagger::BaseModel.respond_to? :required_fields).to eq true
    end

    it 'should set required fields' do
      DAT::Swagger::BaseModel.set_required_fields fields: ['test1', 'test2']
      expect(DAT::Swagger::BaseModel.required_fields).to eq ['test1', 'test2']
    end

    it 'should set the description' do
      DAT::Swagger::BaseModel.set_description description: 'This is a test'
      expect(DAT::Swagger::BaseModel.description).to eq 'This is a test'
    end

  end

  context 'Instance' do
    it 'should respond to #description' do
      expect(DAT::Swagger::BaseModel.new.respond_to? :description).to eq true
    end

    it 'should respond to #required_fields' do
      expect(DAT::Swagger::BaseModel.new.respond_to? :required_fields).to eq true
    end


  end
end