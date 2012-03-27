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
          fetch_collection("invoices", "Invoice", Quickeebooks::Windows::Model::Invoice, filters, page, per_page, sort, options)
        end

      end
    end
  end
end