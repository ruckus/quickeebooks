module Quickeebooks
  module Windows
    module Model
      class CreditChargeResponse  < Quickeebooks::Windows::Model::IntuitType
        xml_name 'CreditChargeResponse'
        xml_accessor :cc_transaction_id,      :from => 'CCTransId'
        xml_accessor :status,                 :from => 'Status'
        xml_accessor :auth_code,              :from => 'AuthCode'
        xml_accessor :avs_street,             :from => 'AvsStreet'
      end
    end
  end
end
