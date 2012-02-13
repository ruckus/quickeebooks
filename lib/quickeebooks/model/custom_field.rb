require "quickeebooks"

module Quickeebooks

  module Model
    class CustomField < IntuitType

      TYPES = %w{BooleanTypeCustomField StringTypeCustomField}
      BOOLEAN_TYPE = "BooleanTypeCustomField"
      STRING_TYPE = "StringTypeCustomField"

      xml_accessor :definition_id, :from => 'DefinitionId'
      xml_accessor :value, :from => 'Value'

    end
  end
end