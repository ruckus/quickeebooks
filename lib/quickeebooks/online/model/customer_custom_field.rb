require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class CustomerCustomField < Quickeebooks::Online::Model::IntuitType

        TYPES = %w{BooleanTypeCustomField StringTypeCustomField}
        BOOLEAN_TYPE = "BooleanTypeCustomField"
        STRING_TYPE = "StringTypeCustomField"

        xml_accessor :definition_id, :from => 'DefinitionId'
        xml_accessor :value, :from => 'Value'

        def to_xml(options = {})
          # Intuit v3 doesnt support custom field updating...
          return ""

          # return "" if value.to_s.empty?
          # xml = %Q{<CustomField xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="#{type_attr}">}
          # xml = "#{xml}<DefinitionId>#{definition_id}</DefinitionId><Value>#{converted_value}</Value></CustomField>"
          # xml
        end

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
