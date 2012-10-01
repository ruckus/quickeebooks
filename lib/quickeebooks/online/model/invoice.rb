# https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/Invoice

require 'quickeebooks/online/model/id'
require 'quickeebooks/online/model/invoice_header'
require 'quickeebooks/online/model/invoice_line_item'
require 'quickeebooks/online/model/address'
require 'quickeebooks/online/model/meta_data'


module Quickeebooks
  module Online
    module Model
      class Invoice < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        
        XML_NODE = "Invoice"
        REST_RESOURCE = "invoice"
        
        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header, :from => 'Header', :as => Quickeebooks::Online::Model::InvoiceHeader
        xml_accessor :bill_address, :from => 'BillAddr', :as => Quickeebooks::Online::Model::Address
        xml_accessor :ship_address, :from => 'ShipAddr', :as => Quickeebooks::Online::Model::Address
        xml_accessor :bill_email, :from => 'BillEmail'
        xml_accessor :ship_method_id, :from => 'ShipMethodId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :ship_method_name, :from => 'ShipMethodName'
        xml_accessor :discount_amount, :from => 'DiscountAmt', :as => Float
        xml_accessor :discount_rate, :from => 'DiscountRate', :as => Float
        xml_accessor :discount_taxable, :from => 'DiscountTaxable'
        xml_accessor :txn_id, :from => 'TxnId'
        xml_accessor :line_items, :from => 'Line', :as => [Quickeebooks::Online::Model::InvoiceLineItem]

        validates_length_of :line_items, :minimum => 1

        def initialize
          ensure_line_items_initialization
        end

        def valid_for_update?
          errors.empty?
        end        

        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end
        
        def to_xml_ns(options = {})
          to_xml_inject_ns(XML_NODE, options)
        end
        
        #== Class methods
        def self.resource_for_collection
          "#{self::REST_RESOURCE}s"
        end
        
        private

        def after_parse
        end

        def ensure_line_items_initialization
          self.line_items ||= []
        end

      end
    end
  end

end
