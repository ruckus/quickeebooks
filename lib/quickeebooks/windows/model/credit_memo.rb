require 'quickeebooks/windows/model/id'
require 'quickeebooks/windows/model/credit_memo_header'
require 'quickeebooks/windows/model/credit_memo_line_item'
require 'quickeebooks/windows/model/address'
require 'quickeebooks/windows/model/meta_data'
require 'quickeebooks/windows/model/tax_line'

module Quickeebooks
  module Windows
    module Model
      class CreditMemo < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'CreditMemos'
        XML_NODE = 'CreditMemo'

        # https://services.intuit.com/sb/creditmemo/v2/<realmID>
        REST_RESOURCE = "creditmemo"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :header, :from => 'Header', :as => Quickeebooks::Windows::Model::CreditMemoHeader
        xml_accessor :line_items, :from => 'Line', :as => [Quickeebooks::Windows::Model::CreditMemoLineItem]
        xml_accessor :tax_line, :from => 'TaxLine', :as => Quickeebooks::Windows::Model::TaxLine

        validates_length_of :line_items, :minimum => 1

        def initialize
          ensure_line_items_initialization
        end

        private

        def ensure_line_items_initialization
          self.line_items ||= []
        end

      end
    end
  end

end
