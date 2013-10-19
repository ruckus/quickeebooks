require 'quickeebooks/online/model/credit_charge_info'
require 'quickeebooks/online/model/credit_charge_response'

module Quickeebooks
  module Online
    module Model
      class CreditCard  < Quickeebooks::Online::Model::IntuitType
        xml_name 'CreditCard'
        xml_accessor :credit_charge_info,     :from => 'CreditChargeInfo',     :as => Quickeebooks::Online::Model::CreditChargeInfo
        xml_accessor :credit_charge_response, :from => 'CreditChargeResponse', :as => Quickeebooks::Online::Model::CreditChargeResponse
      end
    end
  end
end
