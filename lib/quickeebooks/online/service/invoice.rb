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
      end
    end
  end
end
