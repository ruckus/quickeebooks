require 'time'

module Quickeebooks

  module Model
    class InvoiceHeader < IntuitType
      xml_accessor :doc_number, :from => 'DocNumber'
      xml_accessor :txn_date, :from => 'TxnDate', :as => Time
      xml_accessor :msg, :from => 'Msg'
      xml_accessor :customer_id, :from => 'CustomerId'
      xml_accessor :sales_tax_code_id, :from => 'SalesTaxCodeId'
      xml_accessor :sales_tax_code_name, :from => 'SalesTaxCodeName'
      xml_accessor :sub_total_amount, :from => 'SubTotalAmt', :as => Float
      xml_accessor :tax_rate, :from => 'TaxRate', :as => Float
      xml_accessor :total_amount, :from => 'TotalAmt', :as => Float
      xml_accessor :due_date, :from => 'DueDate', :as => Time
      xml_accessor :bill_email, :from => 'BillEmail'
      xml_accessor :discount_amount, :from => 'DiscountAmt', :as => Float
      xml_accessor :status, :from => 'Status'
      xml_accessor :ship_date, :from => 'ShipDate', :as => Time
    end
  end

end