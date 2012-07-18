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
        
        def create(invoice)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">
          xml_node = invoice.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Invoice')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::Invoice, xml)
        end

      end
    end
  end
end