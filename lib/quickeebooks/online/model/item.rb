require 'time'
require "quickeebooks/online/model/id"
require 'quickeebooks/online/model/price'
require 'quickeebooks/online/model/meta_data'
require 'quickeebooks/online/model/account_reference'

module Quickeebooks

  module Online
    module Model
      class Item < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        XML_NODE = "Item"

        # <baseURL>/resource/items/v2/<realmID>
        REST_RESOURCE = "item"

        xml_name 'Item'
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :item_parent_id, :from => 'ItemParentId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :item_parent_name, :from => 'ItemParentName'
        xml_accessor :name, :from => 'Name'
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :unit_price, :from => 'UnitPrice', :as => Quickeebooks::Online::Model::Price
        xml_accessor :account_reference, :from => 'IncomeAccountRef', :as => Quickeebooks::Online::Model::AccountReference
        xml_accessor :purchase_desc, :from => 'PurchaseDesc'
        xml_accessor :purchase_cost, :from => 'PurchaseCost', :as => Quickeebooks::Online::Model::Price
        xml_accessor :expense_account_reference, :from => 'ExpenseAccountRef', :as => Quickeebooks::Online::Model::AccountReference

        validates_presence_of :account_reference
        validates_length_of :name, :within => 1..100

        def to_xml_ns(options = {})
          to_xml_inject_ns('Item', options)
        end

        # To delete a record Intuit requires we provide Id and SyncToken fields
        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        def valid_for_update?
          if sync_token.nil?
            errors.add(:sync_token, "Missing required attribute SyncToken for update")
          end
          valid?
          errors.empty?
        end        

        def taxable?
          taxable == "true"
        end

      end
    end
  end

end
