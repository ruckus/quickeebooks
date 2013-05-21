require 'time'

module Quickeebooks
  module Online
    module Model
      class BillPaymentHeader < Quickeebooks::Online::Model::IntuitType
        xml_name 'Header'
        xml_accessor :doc_number,            :from => 'DocNumber'
        xml_accessor :txn_date,              :from => 'TxnDate',           :as => Time
        xml_accessor :msg,                   :from => 'Msg'
        xml_accessor :note,                  :from => 'Note'
        xml_accessor :status,                :from => 'Status'
        xml_accessor :entity_id,             :from => 'EntityId',          :as => Quickeebooks::Online::Model::Id
        xml_accessor :entity_type,           :from => 'EntityType'
        xml_accessor :bank_account_id,       :from => 'BankAccountId',     :as => Quickeebooks::Online::Model::Id
        xml_accessor :to_be_printed,         :from => 'ToBePrinted'

        xml_accessor :cc_account_id,         :from => 'CCAccountId',       :as => Quickeebooks::Online::Model::Id

        xml_accessor :total_amount,          :from => 'TotalAmt',         :as => Float
      end
    end
  end
end
