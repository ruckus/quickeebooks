require 'time'
require 'quickeebooks/windows/model/payment_detail'

module Quickeebooks
  module Windows
    module Model
      class PaymentHeader < Quickeebooks::Windows::Model::IntuitType
        xml_name 'Header'
        xml_accessor :doc_number,            :from => 'DocNumber'
        xml_accessor :txn_date,              :from => 'TxnDate',            :as => Time
        xml_accessor :note,                  :from => 'Note'
        xml_accessor :status,                :from => 'Status'
        xml_accessor :customer_id,           :from => 'CustomerId',         :as => Quickeebooks::Windows::Model::Id
        xml_accessor :customer_name,         :from => 'CustomerName'
        xml_accessor :deposit_to_account_id, :from => 'DepositToAccountId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :payment_method_id,     :from => 'PaymentMethodId',    :as => Quickeebooks::Windows::Model::Id
        xml_accessor :payment_method_name,   :from => 'PaymentMethodName'
        xml_accessor :detail,                :from => 'Detail',             :as => Quickeebooks::Windows::Model::PaymentDetail
        xml_accessor :total_amount,          :from => 'TotalAmt',           :as => Float
        xml_accessor :process_payment,       :from => 'ProcessPayment'
      end
    end
  end
end
