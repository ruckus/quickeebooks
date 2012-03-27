require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class CustomerCustomField < Quickeebooks::Windows::Model::IntuitType

        TYPES = %w{BooleanTypeCustomField StringTypeCustomField}
        BOOLEAN_TYPE = "BooleanTypeCustomField"
        STRING_TYPE = "StringTypeCustomField"

        xml_accessor :definition_id, :from => 'DefinitionId'
        xml_accessor :value, :from => 'Value'
        xml_accessor :name, :from => 'Name'

        # Intuit sends back "DONT" for "None" but they dont accept it
        # when WE send it back to them, they want "None". ugh....
        def converted_value
          if definition_id == "Preferred Delivery Method"
            if value == "DONT"
              "None"
            else
              value
            end
          else
            value
          end
        end

        def type_attr
          if definition_id == "Bill With Parent"
            "BooleanTypeCustomeField"
          else
            "StringTypeCustomField"
          end
        end

      end
    end
  end
end