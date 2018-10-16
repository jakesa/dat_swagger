require_relative 'model'

module DAT::Swagger
  class BaseModel < Model
    class << self

      def set_required_fields(fields:)
        @required_fields ||= []
        fields.each do |field|
          @required_fields << field
        end unless fields.nil?
      end

      def set_description(description:)
        @description = description
      end

      def description
        @description
      end

      def required_fields
        @required_fields
      end

    end

    def description
      self.class.description.dup
    end

    def required_fields
      self.class.required_fields.dup
    end

  end
end