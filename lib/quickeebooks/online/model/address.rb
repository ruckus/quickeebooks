require 'quickeebooks'

module Quickeebooks
  module Online
    module Model
      class Address < Quickeebooks::Online::Model::IntuitType
        xml_accessor :line1, :from => 'Line1'
        xml_accessor :line2, :from => 'Line2'
        xml_accessor :line3, :from => 'Line3'
        xml_accessor :line4, :from => 'Line4'
        xml_accessor :line5, :from => 'Line5'
        xml_accessor :city, :from => 'City'
        xml_accessor :country, :from => 'Country'
        xml_accessor :country_sub_division_code, :from => 'CountrySubDivisionCode'
        xml_accessor :postal_code, :from => 'PostalCode'
        xml_accessor :tag, :from => 'Tag'

        def zip
          postal_code
        end

        def to_xml_ns(options = {})
          options.merge!(:destination_name => 'Address')
          to_xml_inject_ns('Address', options)
        end

      end
    end

  end
end

=begin
<Address>
  <Line1>123 Main St.</Line1>
  <Line2>Suite 400</Line2>
  <City>San Diego</City>
  <Country>USA</Country>
  <CountrySubDivisionCode>CA</CountrySubDivisionCode>
  <PostalCode>96009</PostalCode>
  <Tag>Billing</Tag>
</Address>
=end
