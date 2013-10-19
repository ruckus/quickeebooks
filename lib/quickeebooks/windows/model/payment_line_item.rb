require 'quickeebooks/windows/model/id'

module Quickeebooks
  module Windows
    module Model
      class PaymentLineItem < Quickeebooks::Windows::Model::IntuitType
        xml_name 'Line'
        xml_accessor :id,         :from => 'Id',        :as => Integer
        xml_accessor :desc,       :from => 'Desc'
        xml_accessor :amount,     :from => 'Amount',    :as => Float
        xml_accessor :txn_id,     :from => 'TxnId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :txn_num,    :from => 'TxnNum'
      end
    end
  end
end
