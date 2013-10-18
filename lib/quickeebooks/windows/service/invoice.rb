require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/invoice'
require 'quickeebooks/windows/model/invoice_header'
require 'quickeebooks/windows/model/invoice_line_item'
require 'tempfile'

module Quickeebooks
  module Windows
    module Service
      class Invoice < Quickeebooks::Windows::Service::ServiceBase

        # Fetch a +Collection+ of +Invoice+ objects
        # Arguments:
        # filters: Array of +Filter+ objects to apply
        # page: +Fixnum+ Starting page
        # per_page: +Fixnum+ How many results to fetch per page
        # sort: +Sort+ object
        # options: +Hash+ extra arguments
        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::Invoice, nil, filters, page, per_page, sort, options)
        end

        def invoice_as_pdf(invoice_id, destination_file_name)
          raise NoMethodError, 'invoice_as_pdf is not implemented in Quickeebooks for Windows, only available in the Online adapter.'
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Invoice::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Invoice, url, {:idDomain => idDomain})
        end

        def create(invoice)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">
          xml_node = invoice.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Invoice')
          xml = Quickeebooks::Shared::Service::OperationNode.new.add do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::Invoice, xml)
        end

        def update(invoice)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">

          # Intuit requires that some fields are unset / do not exist.
          invoice.meta_data = nil
          invoice.external_key = nil

          # unset Id fields in addresses
          if invoice.header.billing_address
            invoice.header.billing_address.id = nil
          end

          if invoice.header.shipping_address
            invoice.header.shipping_address.id = nil
          end

          xml_node = invoice.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Invoice')
          xml = Quickeebooks::Shared::Service::OperationNode.new.mod do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::Invoice, xml)
        end

      end
    end
  end
end
