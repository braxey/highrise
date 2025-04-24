module TrimStrings
  extend ActiveSupport::Concern

  included do
    class_attribute :trim_only, :trim_except, default: nil
    before_validation :trim_strings
  end

  class_methods do
    def trim_strings_only(*attributes)
      self.trim_only = attributes.map(&:to_s)
    end

    def trim_strings_except(*attributes)
      self.trim_except = attributes.map(&:to_s)
    end
  end

  private
    def trim_strings
      attributes_to_trim.each do |attr|
        value = send(attr)
        if value.is_a?(String) && value.respond_to?(:strip)
          send("#{attr}=", value.strip)
        end
      end
    end

    def attributes_to_trim
      if trim_only
        trim_only & attribute_names
      elsif trim_except
        attribute_names - trim_except
      else
        attribute_names.select { |attr| string_attribute?(attr) }
      end
    end

    def string_attribute?(attr)
      type = self.class.attribute_types[attr]
      type.is_a?(ActiveModel::Type::String)
    end
end
