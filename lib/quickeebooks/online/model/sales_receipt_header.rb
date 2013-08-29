require 'quickeebooks/common/date_time'

module Quickeebooks
  module Online
    module Model
      class SalesReceiptHeader < Quickeebooks::Online::Model::IntuitType
        xml_name 'Header'
        xml_accessor :doc_number,              :from => 'DocNumber'
        xml_accessor :txn_date,                :from => 'TxnDate',                    :as => Quickeebooks::Common::DateTime
        xml_accessor :msg,                     :from => 'Msg'
        xml_accessor :note,                    :from => 'Note'
        xml_accessor :status,                  :from => 'Status'
        xml_accessor :customer_id,             :from => 'CustomerId',                 :as => Quickeebooks::Online::Model::Id
        xml_accessor :customer_name,           :from => 'CustomerName'
        xml_accessor :subtotal_amount,         :from => 'SubTotalAmt',                :as => Float
        xml_accessor :total_amount,            :from => 'TotalAmt',                   :as => Float
        xml_accessor :deposit_to_account_name, :from => 'DepositToAccountName'
        xml_accessor :deposit_to_account_id,   :from => 'DepositToAccountId',         :as => Quickeebooks::Online::Model::Id
        xml_accessor :shipping_address,        :from => 'ShipAddr',                   :as => Quickeebooks::Online::Model::Address
        xml_accessor :ship_method_id,          :from => 'ShipMethodId',               :as => Quickeebooks::Online::Model::Id
        xml_accessor :ship_method_name,        :from => 'ShipMethodName'
        xml_accessor :payment_method_id,       :from => "PaymentMethodId",            :as => Quickeebooks::Online::Model::Id
        xml_accessor :payment_method_name,     :from => "PaymentMethodName"
      end
    end
  end
end
