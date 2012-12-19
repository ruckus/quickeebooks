require 'quickeebooks/windows/model/item'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Item < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          custom_field_query = '<?xml version="1.0" encoding="utf-8"?>'
          custom_field_query += '<ItemQuery xmlns="http://www.intuit.com/sb/cdm/v2">'
          custom_field_query += "<StartPage>#{page}</StartPage><ChunkSize>#{per_page}</ChunkSize>"
          custom_field_query += '<CustomFieldEnable>true</CustomFieldEnable></ItemQuery>'
          fetch_collection(Quickeebooks::Windows::Model::Item, custom_field_query.strip, filters, page, per_page, sort, options)
        end

        def create(item)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Item">
          xml_node = item.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Item')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::Item, xml)
        end

      end
    end
    
  end
end