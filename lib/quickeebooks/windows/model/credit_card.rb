require 'quickeebooks/windows/model/credit_charge_info'
require 'quickeebooks/windows/model/credit_charge_response'

module Quickeebooks
  module Windows
    module Model
      class CreditCard  < Quickeebooks::Windows::Model::IntuitType
        xml_name 'CreditCard'
        xml_accessor :credit_charge_info,     :from => 'CreditChargeInfo',     :as => Quickeebooks::Windows::Model::CreditChargeInfo
        xml_accessor :credit_charge_response, :from => 'CreditChargeResponse', :as => Quickeebooks::Windows::Model::CreditChargeResponse
      end
    end
  end
end
