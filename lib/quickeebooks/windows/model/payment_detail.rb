require 'quickeebooks/windows/model/credit_card'

module Quickeebooks
  module Windows
    module Model
      class PaymentDetail  < Quickeebooks::Windows::Model::IntuitType
        xml_name 'Detail'
        xml_accessor :credit_card, :from => 'CreditCard', :as => Quickeebooks::Windows::Model::CreditCard
      end
    end
  end
end
