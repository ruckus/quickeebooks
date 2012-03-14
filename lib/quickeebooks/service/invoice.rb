require 'quickeebooks/service/service_base'
require 'quickeebooks/model/invoice'
require 'quickeebooks/model/invoice_header'
require 'quickeebooks/model/invoice_line_item'
require 'tempfile'

module Quickeebooks
  module Service
    class Invoice < ServiceBase

      
      # Fetch a +Collection+ of +Invoice+ objects
      # Arguments:
      # filters: Array of +Filter+ objects to apply
      # page: +Fixnum+ Starting page
      # per_page: +Fixnum+ How many results to fetch per page
      # sort: +Sort+ object
      # options: +Hash+ extra arguments
      def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
        fetch_collection("invoices", "Invoice", Quickeebooks::Model::Invoice, filters, page, per_page, sort, options)
      end

      # Returns the absolute path to the PDF on disk
      # Its left to the caller to unlink the file at some later date
      # Returns: +String+ : absolute path to file on disk or nil if couldnt fetch PDF
      def invoice_as_pdf(invoice_id, destination_parent_directory)
        response = do_http_get("#{url_for_resource("invoice-document")}/#{invoice_id}", {}, {'Content-Type' => 'application/pdf'})
        if response && response.code.to_i == 200
          file_name = File.join(destination_parent_directory, "invoice-document-#{invoice_id}-#{Time.now.strftime('%Y-%m-%d_%H-%M')}.pdf")
          File.open(file_name, "wb") do |file|
            file.write(response.body)
          end
          file_name
        else
          nil
        end
      end
      
      # Fetch an invoice by its ID
      # Returns: +Invoice+ object
      def fetch_by_id(invoice_id)
        response = do_http_get("#{url_for_resource("invoice")}/#{invoice_id}")
        Quickeebooks::Model::Invoice.from_xml(response.body)
      end
      
    end
  end
end