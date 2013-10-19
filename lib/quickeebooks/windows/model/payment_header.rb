require 'time'
require 'quickeebooks/windows/model/payment_detail'

module Quickeebooks
  module Windows
    module Model
      class PaymentHeader < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        xml_name 'Header'
        xml_accessor :doc_number,               :from => 'DocNumber'
        xml_accessor :txn_date,                 :from => 'TxnDate',           :as => Time
        xml_accessor :currency,                 :from => 'Currency'
        xml_accessor :note,                     :from => 'Note'
        xml_accessor :status,                   :from => 'Status'
        xml_accessor :customer_id,              :from => 'CustomerId',        :as => Quickeebooks::Windows::Model::Id
        xml_accessor :customer_name,            :from => 'CustomerName'
        xml_accessor :job_id,                   :from => 'JobId',             :as => Quickeebooks::Windows::Model::Id
        xml_accessor :job_name,                 :from => 'JobName'
        xml_accessor :remit_to_id,              :from => 'RemitToId',         :as => Quickeebooks::Windows::Model::Id
        xml_accessor :remit_to_name,            :from => 'RemitToName'
        xml_accessor :ar_account_id,            :from => 'ARAccountId',       :as => Quickeebooks::Windows::Model::Id
        xml_accessor :ar_account_name,          :from => 'ARAccountName'
        xml_accessor :deposit_to_account_id,    :from => 'DepositToAccountId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :deposit_to_account_name,  :from => 'DepositToAccountName'
        xml_accessor :payment_method_id,        :from => 'PaymentMethodId',    :as => Quickeebooks::Windows::Model::Id
        xml_accessor :payment_method_name,      :from => 'PaymentMethodName'
        xml_accessor :detail,                   :from => 'Detail',             :as => Quickeebooks::Windows::Model::PaymentDetail
        xml_accessor :total_amount,             :from => 'TotalAmt',           :as => Float
        xml_accessor :process_payment,          :from => 'ProcessPayment'

        validate :customer_is_valid

        private

        def customer_is_valid
          if customer_id.nil?
            errors.add(:customer_id, "Missing customer_id")
          else
            # ensure its we have a non-blank Customer ID value
            if customer_id.to_s.length == 0
              errors.add(:customer_id, "customer_id is supplied but its value is empty")
            end
          end
        end

      end
    end
  end
end
