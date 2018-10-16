require_relative 'base_model'

module DAT
  module Swagger
    class ModelBuilder
      class << self
        # definitions needs to be a hash with the key being the name and the value being a hash containing the keys [:required, :properties, :description]
        def build(definitions:, super_class: DAT::Swagger::BaseModel)
          models = []
          definitions.each do |name, attr_hash|
            name = name[0].capitalize + name.slice(1..name.length-1)
            model = Class.new(super_class)
            set_model name: name, obj: model
            define_model name: name, methods: {
                define_fields: {fields: attr_hash[:properties].keys},
                set_description: {description: attr_hash[:description]},
                set_required_fields: {fields: attr_hash[:required]}
            }
            models << name
          end
          models
        end

        def set_model(name:, obj:)
          DAT::Swagger.const_set(name, obj) unless DAT::Swagger.const_defined?(name)
        end

        def define_model(name:, methods:)
          methods.each do |method, values|
            DAT::Swagger.const_get(name).send(method, values)
          end
        end
      end

    end

  end
end
