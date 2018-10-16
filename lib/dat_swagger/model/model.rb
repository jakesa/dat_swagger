module DAT
  module Swagger
    class Model

      def self.define_fields(fields:[])
        @fields = []
        fields = [fields] unless fields.is_a? Array
        fields.each do |field|
          @fields << field
          attr_accessor field
        end
      end

      def self.fields
        @fields ||=[]
      end

      def self.set_defaults(values:{})
        @defaults = values
      end

      def self.defaults
        @defaults ||= {}
      end

      def initialize(values:{})
        load_default_data
        load_data data: values
        yield self if block_given?
      end

      def to_hash
        hash = {}
        self.class.fields.each do |field|
          hash[field] = send(field)
        end
        hash
      end

      def to_s
        str = ''
        to_hash.each do |field, value|
          str << ":#{field} => #{value}\n"
        end
        str
      end

      protected

      def load_data(data: self.class.defaults)
        data.each do |field, value|
          begin
            send("#{field}=", value)
          rescue NoMethodError
            raise FieldNotDefined.new "-- #{field} -- is not a defined property of #{self.class}."
          end
        end
      end

      alias_method :load_default_data, :load_data


    end

    class FieldNotDefined < ArgumentError;end
  end
end