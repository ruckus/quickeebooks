require 'time'

module Quickeebooks
  module Online
    module Model
      class BillHeader < Quickeebooks::Online::Model::IntuitType
        xml_name 'Header'
        xml_accessor :doc_number,            :from => 'DocNumber'
        xml_accessor :txn_date,              :from => 'TxnDate',            :as => Time
        xml_accessor :msg,                   :from => 'Msg'
        xml_accessor :note,                  :from => 'Note'
        xml_accessor :status,                :from => 'Status'
        xml_accessor :vendor_id,             :from => 'VendorId',           :as => Quickeebooks::Online::Model::Id
        xml_accessor :total_amount,          :from => 'TotalAmt',           :as => Float
        xml_accessor :sales_term_id,         :from => 'SalesTermId',        :as => Quickeebooks::Online::Model::Id
        xml_accessor :due_date,              :from => 'DueDate',            :as => Time
        xml_accessor :balance,               :from => 'Balance',            :as => Float
      end
    end
  end
end
