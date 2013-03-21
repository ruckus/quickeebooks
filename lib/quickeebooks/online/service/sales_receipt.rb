require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/sales_receipt'
require 'quickeebooks/online/model/sales_receipt_header'
require 'quickeebooks/online/model/sales_receipt_line_item'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class SalesReceipt < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
