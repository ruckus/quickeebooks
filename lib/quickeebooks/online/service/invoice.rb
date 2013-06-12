require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/invoice'
require 'quickeebooks/online/model/invoice_header'
require 'quickeebooks/online/model/invoice_line_item'
require 'tempfile'

module Quickeebooks
  module Online
    module Service
      class Invoice < ServiceBase
        include ServiceCRUD
        # Returns the absolute path to the PDF on disk
        # Its left to the caller to unlink the file at some later date
        # Returns: +String+ : absolute path to file on disk or nil if couldn't fetch PDF
        def invoice_as_pdf(invoice_id, destination_file_name)
          response = do_http_get("#{url_for_resource("invoice-document")}/#{invoice_id}", {}, {'Content-Type' => 'application/pdf'})
          File.open(destination_file_name, "wb") do |file|
            file.write(response.body)
          end
          destination_file_name
        rescue => e
          log "Error downloading invoice id #{invoice_id} pdf file #{destination_file_name} with #{e}"
          nil
        end

      end
    end
  end
end
