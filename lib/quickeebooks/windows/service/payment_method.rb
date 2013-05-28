# require 'quickeebooks/windows/service/service_base'
# require 'quickeebooks/windows/model/payment'
# require 'quickeebooks/windows/model/payment_method'
# require 'quickeebooks/windows/model/payment_line_item'
# require 'quickeebooks/windows/model/payment_detail'
# require 'quickeebooks/windows/model/credit_card'
# require 'quickeebooks/windows/model/credit_charge_info'
# require 'quickeebooks/windows/model/credit_charge_response'
# require 'nokogiri'

module Quickeebooks
  module Windows
    module Service
      class PaymentMethod < ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::PaymentMethod, nil, filters, page, per_page, sort, options)
        end
        
        
      end
    end
  end
end
