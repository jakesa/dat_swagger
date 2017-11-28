require_relative 'spec_helper'
require 'pry'
describe DATSwagger::Config do

  it 'should have reader properties :get, :post, :patch, :delete, :put, :models' do
    properties = [:get, :post, :patch, :delete, :put, :models]
    config = DATSwagger::Config.new
    properties.each do |prop|
      expect(config.respond_to? prop).to eq true
    end
  end

  it 'should have read/write properties :host, :port, :headers, :url' do
    properties = [:host, :port, :headers, :url]
    config = DATSwagger::Config.new
    properties.each do |prop|
      expect(config.respond_to? prop).to eq true
    end
  end

  it 'should default all default all reader properties to empty arrays' do
    properties = [:get, :post, :patch, :delete, :put, :models]
    config = DATSwagger::Config.new
    properties.each do |prop|
      expect(config.send(prop).empty?).to eq true
    end
  end

  it 'should have a getter and setter for file_path' do
    config = DATSwagger::Config.new
    expect(config.respond_to? :file_path).to eq true
    expect(config.respond_to? :file_path=).to eq true
  end

  it 'should create properties if they dont exist' do
    config = DATSwagger::Config.new
    expect(config.respond_to? :test_prop).to eq false
    config.test_prop = 'test'
    expect(config.test_prop).to eq 'test'
  end

  it 'should respond to load_swagger_file' do
    config = DATSwagger::Config.new
    expect(config.respond_to? :load_swagger_file).to eq true
  end

  it 'take in a swagger file as an argument' do
    config = DATSwagger::Config.new('./spec/resultsAPI-swagger.json')
    expect(config.nil?).to eq false
  end

  it 'should be able to assign a swagger file with #file_path=' do
    config = DATSwagger::Config.new
    config.file_path = './spec/resultsAPI-swagger.json'

  end

  it 'should create routes based on the swagger file loaded' do
    config = DATSwagger::Config.new './spec/resultsAPI-swagger.json'

    expect(config.get.empty?).to be false
    expect(config.post.empty?).to be false
    expect(config.put.empty?).to be false
    expect(config.patch.empty?).to be false
    expect(config.delete.empty?).to be false
  end


end
