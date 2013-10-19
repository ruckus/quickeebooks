# https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/Invoice

require 'quickeebooks/online/model/id'
require 'quickeebooks/online/model/invoice_header'
require 'quickeebooks/online/model/invoice_line_item'
require 'quickeebooks/online/model/address'
require 'quickeebooks/online/model/meta_data'
require 'quickeebooks/common/online_line_item_model_methods'


module Quickeebooks
  module Online
    module Model
      class Invoice < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineLineItemModelMethods

        XML_NODE = "Invoice"
        REST_RESOURCE = "invoice"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header, :from => 'Header', :as => Quickeebooks::Online::Model::InvoiceHeader
        xml_accessor :bill_email, :from => 'BillEmail'
        xml_accessor :ship_method_id, :from => 'ShipMethodId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :ship_method_name, :from => 'ShipMethodName'
        xml_accessor :discount_amount, :from => 'DiscountAmt', :as => Float
        xml_accessor :discount_rate, :from => 'DiscountRate', :as => Float
        xml_accessor :discount_taxable, :from => 'DiscountTaxable'
        xml_accessor :txn_id, :from => 'TxnId'
        xml_accessor :line_items, :from => 'Line', :as => [Quickeebooks::Online::Model::InvoiceLineItem]

        validates_length_of :line_items, :minimum => 1

      end
    end
  end

end
