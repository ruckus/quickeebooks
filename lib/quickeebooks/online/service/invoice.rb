require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/invoice'
require 'quickeebooks/online/model/invoice_header'
require 'quickeebooks/online/model/invoice_line_item'
require 'tempfile'

module Quickeebooks
  module Online
    module Service
      class Invoice < ServiceBase

        def create(invoice)
          raise InvalidModelException unless invoice.valid?
          xml = invoice.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Online::Model::Invoice.resource_for_singular), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Invoice.from_xml(response.body)
          else
            nil
          end
        end

        # Fetch an invoice by its ID
        # Returns: +Invoice+ object
        def fetch_by_id(invoice_id)
          response = do_http_get("#{url_for_resource(Quickeebooks::Online::Model::Invoice::REST_RESOURCE)}/#{invoice_id}")
          Quickeebooks::Online::Model::Invoice.from_xml(response.body)
        end

        def update(invoice)
          raise InvalidModelException.new("Missing required parameters for update") unless invoice.valid_for_update?
          url = "#{url_for_resource(Quickeebooks::Online::Model::Invoice.resource_for_singular)}/#{invoice.id.value}"
          xml = invoice.to_xml_ns
          response = do_http_post(url, valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Invoice.from_xml(response.body)
          else
            nil
          end
        end
        
        # Fetch a +Collection+ of +Invoice+ objects
        # Arguments:
        # filters: Array of +Filter+ objects to apply
        # page: +Fixnum+ Starting page
        # per_page: +Fixnum+ How many results to fetch per page
        # sort: +Sort+ object
        # options: +Hash+ extra arguments
        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::Invoice, filters, page, per_page, sort, options)
        end

        # Returns the absolute path to the PDF on disk
        # Its left to the caller to unlink the file at some later date
        # Returns: +String+ : absolute path to file on disk or nil if couldnt fetch PDF
        def invoice_as_pdf(invoice_id, destination_file_name)
          response = do_http_get("#{url_for_resource("invoice-document")}/#{invoice_id}", {}, {'Content-Type' => 'application/pdf'})
          if response && response.code.to_i == 200
            File.open(destination_file_name, "wb") do |file|
              file.write(response.body)
            end
            destination_file_name
          else
            nil
          end
        end

        def delete(invoice)
          raise InvalidModelException.new("Missing required parameters for delete") unless invoice.valid_for_deletion?
          xml = valid_xml_document(invoice.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource(Quickeebooks::Online::Model::Invoice::REST_RESOURCE)}/#{invoice.id}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

      end
    end
  end
end