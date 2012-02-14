# https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/Invoice

require 'quickeebooks/model/invoice_header'
require 'quickeebooks/model/invoice_line_item'
require 'quickeebooks/model/address'
require 'quickeebooks/model/meta_data'


module Quickeebooks

  module Model
    class Invoice < IntuitType
      xml_convention :camelcase
      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Model::MetaData
      xml_accessor :header, :from => 'Header', :as => Quickeebooks::Model::InvoiceHeader
      xml_accessor :bill_address, :from => 'BillAddr', :as => Quickeebooks::Model::Address
      xml_accessor :ship_address, :from => 'ShipAddr', :as => Quickeebooks::Model::Address
      xml_accessor :bill_email, :from => 'BillEmail'
      xml_accessor :ship_method_id, :from => 'ShipMethodId'
      xml_accessor :ship_method_name, :from => 'ShipMethodName'
      xml_accessor :balance, :from => 'Balance', :as => Float
      xml_accessor :discount_amount, :from => 'DiscountAmt', :as => Float
      xml_accessor :discount_rate, :from => 'DiscountRate', :as => Float
      xml_accessor :discount_taxable, :from => 'DiscountTaxable'
      xml_accessor :txn_id, :from => 'TxnId'
      xml_accessor :line_items, :from => 'Line', :as => [Quickeebooks::Model::InvoiceLineItem]
    end
  end

end