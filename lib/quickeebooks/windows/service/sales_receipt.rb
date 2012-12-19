require 'quickeebooks/windows/model/sales_receipt'
require 'quickeebooks/windows/model/sales_receipt_header'
require 'quickeebooks/windows/model/sales_receipt_line_item'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class SalesReceipt < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          custom_field_query = '<?xml version="1.0" encoding="utf-8"?>'
          custom_field_query += '<SalesReceiptQuery xmlns="http://www.intuit.com/sb/cdm/v2">'
          custom_field_query += "<StartPage>#{page}</StartPage><ChunkSize>#{per_page}</ChunkSize>"
          custom_field_query += '<CustomFieldEnable>true</CustomFieldEnable></SalesReceiptQuery>'
          fetch_collection(Quickeebooks::Windows::Model::SalesReceipt, custom_field_query.strip, filters, page, per_page, sort, options)
        end

        def create(sales_receipt)
          raise InvalidModelException unless sales_receipt.valid_for_create?
          
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">
          xml_node = sales_receipt.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'SalesReceipt')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::SalesReceipt, xml)
        end

      end
    end
    
  end
end