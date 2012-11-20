require 'time'

module Quickeebooks
  module Online
    module Model
      class InvoiceHeader < Quickeebooks::Online::Model::IntuitType

        IS_TAXABLE = "IS_TAXABLE"

        xml_name 'Header'
        xml_accessor :doc_number, :from => 'DocNumber'
        xml_accessor :txn_date, :from => 'TxnDate', :as => Time
        xml_accessor :msg, :from => 'Msg'
        xml_accessor :customer_id, :from => 'CustomerId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :sales_tax_code_id, :from => 'SalesTaxCodeId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sales_tax_code_name, :from => 'SalesTaxCodeName'
        xml_accessor :sub_total_amount, :from => 'SubTotalAmt', :as => Float
        xml_accessor :tax_rate, :from => 'TaxRate', :as => Float
        xml_accessor :tax_amount, :from => 'TaxAmt', :as => Float
        xml_accessor :balance, :from => 'Balance', :as => Float
        xml_accessor :total_amount, :from => 'TotalAmt', :as => Float
        xml_accessor :due_date, :from => 'DueDate', :as => Time
        xml_accessor :bill_email, :from => 'BillEmail'
        xml_accessor :discount_amount, :from => 'DiscountAmt', :as => Float
        xml_accessor :status, :from => 'Status'
        xml_accessor :ship_date, :from => 'ShipDate', :as => Time
        xml_accessor :to_be_emailed, :from => 'ToBeEmailed'
      end
    end
  end

end
