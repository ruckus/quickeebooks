require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/bill_payment'
require 'quickeebooks/online/model/bill_payment_header'
require 'quickeebooks/online/model/bill_payment_line_item'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class BillPayment < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
