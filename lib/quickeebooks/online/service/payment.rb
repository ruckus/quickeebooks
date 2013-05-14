require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/payment'
require 'quickeebooks/online/model/payment_header'
require 'quickeebooks/online/model/payment_line_item'
require 'quickeebooks/online/model/payment_detail'
require 'quickeebooks/online/model/credit_card'
require 'quickeebooks/online/model/credit_charge_info'
require 'quickeebooks/online/model/credit_charge_response'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Payment < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
