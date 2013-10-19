require 'quickeebooks'

module Quickeebooks
  module Windows
    module Model
      class Address < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :id, :from => 'Id'
        xml_accessor :line1, :from => 'Line1'
        xml_accessor :line2, :from => 'Line2'
        xml_accessor :line3, :from => 'Line3'
        xml_accessor :line4, :from => 'Line4'
        xml_accessor :line5, :from => 'Line5'
        xml_accessor :city, :from => 'City'
        xml_accessor :country, :from => 'Country'
        xml_accessor :country_sub_division_code, :from => 'CountrySubDivisionCode'
        xml_accessor :postal_code, :from => 'PostalCode'
        xml_accessor :postal_code_suffix, :from => 'PostalCodeSuffix'
        xml_accessor :default, :from => 'Default'
        xml_accessor :tag, :from => 'Tag'

        def zip
          postal_code
        end

        def to_xml_ns
          to_xml
        end

        def default?
          default == "true"
        end

        def state
          country_sub_division_code
        end

        def state=(new_state)
          self.country_sub_division_code = new_state
        end

      end
    end
  end
end
