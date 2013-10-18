require 'quickeebooks/online/model/credit_card'

module Quickeebooks
  module Online
    module Model
      class PaymentDetail  < Quickeebooks::Online::Model::IntuitType
        xml_name 'Detail'
        xml_accessor :credit_card, :from => 'CreditCard', :as => Quickeebooks::Online::Model::CreditCard
      end
    end
  end
end
