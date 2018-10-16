require 'json'
require_relative '../utils'

module DAT::Swagger
  class Config
    extend Utils
    def self.defaults
      {
          swagger_file_path: nil,
          config_file_path: resolve_path('./config.json')
      }.freeze
    end

    attr_reader :attrs
    def initialize(fields: {})
      @attrs ||=[]
      load_defaults
      load_data fields
      yield self if block_given?
    end

    def to_hash(*fields)
      return_hash = {}
      if fields.empty?
        attrs.each { |field| return_hash[field]= send(field) }
      else
        fields.flatten.each do |field|
          begin
            return_hash[field.to_sym] = send(field)
          rescue NoMethodError
            puts "Warning: the following field was requested but does not exist - #{field}"
            nil
          end
        end
      end
      return_hash
    end

    def save_config(file_path: config_file_path)
      file = File.new file_path, 'w'
      file.puts(JSON.pretty_generate(to_hash))
      file.close
      self
    end

    def load_config(file_path: config_file_path)
      if File.file? file_path
        file = File.new file_path, 'r'
        load_data JSON.parse(File.read(file_path), symbolize_names: true)
        file.close
      end
      self
    end

    # catch any field assignments that dont exist and create them. Otherwise pass it along to super
    def method_missing(name, *args, &block)
      value = args[0]
      if name.match(/^.*=/) != nil
        unless respond_to?(name) || respond_to?("#{name.to_s.gsub('=','')}".to_sym)
          self.class.attr_accessor name.to_s.gsub('=','').to_sym
          @attrs << name.to_s.gsub('=','').to_sym
          send(name, value)
        end
      else
        super
      end
    end

    protected
    def load_data(data: self.class.defaults)
      data.each do |field, value|
        send("#{field}=", value)
        @attrs << field
      end
      @attrs.uniq!
    end

    alias_method :load_defaults, :load_data

  end
end