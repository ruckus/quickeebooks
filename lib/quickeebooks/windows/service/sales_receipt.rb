require 'quickeebooks/windows/model/sales_receipt'
require 'quickeebooks/windows/model/sales_receipt_header'
require 'quickeebooks/windows/model/sales_receipt_line_item'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class SalesReceipt < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          filters << Quickeebooks::Shared::Service::Filter.new(:boolean, :field => 'CustomFieldEnable', :value => true)
          fetch_collection(Quickeebooks::Windows::Model::SalesReceipt, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::SalesReceipt::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::SalesReceipt, url, {:idDomain => idDomain})
        end

        def create(sales_receipt)
          raise InvalidModelException unless sales_receipt.valid_for_create?

          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">
          xml_node = sales_receipt.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'SalesReceipt')
          xml = Quickeebooks::Shared::Service::OperationNode.new.add do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::SalesReceipt, xml)
        end

        def update(sales_receipt)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">

          # Intuit requires that some fields are unset / do not exist.
          sales_receipt.meta_data = nil
          sales_receipt.external_key = nil

          xml_node = sales_receipt.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'SalesReceipt')

          xml = Quickeebooks::Shared::Service::OperationNode.new.mod do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId> #{xml_node}"
          end

          perform_write(Quickeebooks::Windows::Model::SalesReceipt, xml)
        end

      end
    end

  end
end
