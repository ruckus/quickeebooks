require 'time'
require 'quickeebooks/windows/model/price'
require 'quickeebooks/windows/model/meta_data'
require 'quickeebooks/windows/model/account_reference'
require 'quickeebooks/windows/model/vendor_reference'

module Quickeebooks
  module Windows
    module Model
      class Item < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Items'
        XML_NODE = 'Item'

        # https://services.intuit.com/sb/item/v2/<realmID>
        REST_RESOURCE = "item"

        xml_name 'Item'
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :item_parent_id, :from => 'ItemParentId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :item_parent_name, :from => 'ItemParentName'
        xml_accessor :name, :from => 'Name'
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :unit_price, :from => 'UnitPrice', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :active
        xml_accessor :rate_percent, :from => 'RatePercent'
        xml_accessor :type, :from => 'Type'
        xml_accessor :uomid, :from => 'UOMId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :uomabbrv, :from => 'UOMAbbrv'
        xml_accessor :account_reference, :from => 'IncomeAccountRef', :as => Quickeebooks::Windows::Model::AccountReference
        xml_accessor :purchase_desc, :from => 'PurchaseDesc'
        xml_accessor :purchase_cost, :from => 'PurchaseCost', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :expense_account_reference, :from => 'ExpenseAccountRef', :as => Quickeebooks::Windows::Model::AccountReference
        xml_accessor :cogs_account_reference, :from => 'COGSAccountRef', :as => Quickeebooks::Windows::Model::AccountReference
        xml_accessor :pref_vendor_ref, :from => 'VendorRef', :as => Quickeebooks::Windows::Model::VendorReference
        xml_accessor :avg_cost, :from => 'AvgCost', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :qty_on_hand, :from => 'QtyOnHand', :as => Float
        xml_accessor :qty_on_purchase_order, :from => 'QtyOnPurchaseOrder', :as => Float
        xml_accessor :qty_on_sales_order, :from => 'QtyOnSalesOrder', :as => Float
        xml_accessor :reorder_point, :from => 'ReorderPoint', :as => Float
        xml_accessor :man_part_num, :from => 'ManPartNum'
        xml_accessor :print_grouped_items, :from => 'PrintGroupedItems'

        def to_xml_ns(options = {})
          to_xml(options)
        end

        # To delete a record Intuit requires we provide Id and SyncToken fields
        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        def taxable?
          taxable == "true"
        end

        def active?
          active == "true"
        end

        def draft?
          draft == "true"
        end

        def print_grouped_items?
          print_grouped_items == "true"
        end

        def synchronized?
          synchronized == "true"
        end

      end
    end
  end

end
