require 'quickeebooks'
require 'quickeebooks/windows/model/id'
require 'quickeebooks/windows/model/external_key'
require 'quickeebooks/windows/model/meta_data'

module Quickeebooks
  module Windows
    module Model
      class SalesReceipt < Quickeebooks::Windows::Model::IntuitType

    		XML_COLLECTION_NODE = 'SalesReceipts'
    		XML_NODE = 'SalesReceipt'

    		# https://services.intuit.com/sb/salesreceipt/v2/<realmID>
    		REST_RESOURCE = "salesreceipt"

    		xml_convention :camelcase
        xml_accessor :id, :as => Quickeebooks::Windows::Model::Id
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :as => Quickeebooks::Windows::Model::ExternalKey
        xml_accessor :synchronized
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :header, :from => 'Header', :as => Quickeebooks::Windows::Model::SalesReceiptHeader
        xml_accessor :line_items, :from => 'Line', :as => [Quickeebooks::Windows::Model::SalesReceiptLineItem]
        xml_accessor :tax_line, :from => 'TaxLine', :as => Quickeebooks::Windows::Model::TaxLine

        def valid_for_create?
          true
        end

      end
    end
  end
end
