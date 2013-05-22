module Quickeebooks
  module Online
    module Model
      class BillPaymentLineItem < Quickeebooks::Online::Model::IntuitType
        xml_name 'Line'
        xml_accessor :id,                         :from => 'Id',                      :as => Integer
        xml_accessor :desc,                       :from => 'Desc'
        xml_accessor :amount,                     :from => 'Amount',                  :as => Float
        xml_accessor :txn_id,                     :from => 'TxnId',                 :as => Quickeebooks::Online::Model::Id
      end
    end
  end
end
