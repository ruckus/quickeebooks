require 'quickeebooks/online/model/payment_method'
require 'quickeebooks/online/service/service_base'

module Quickeebooks
  module Online
    module Service
      class PaymentMethod < ServiceBase
        include ServiceCRUD
      end
    end
  end
end