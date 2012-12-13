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
        xml_accessor :asset_account_reference, :from => 'AssetAccountRef', :as => Quickeebooks::Windows::Model::AccountReference
        xml_accessor :pref_vendor_ref, :from => 'VendorRef', :as => Quickeebooks::Windows::Model::VendorReference
        xml_accessor :avg_cost, :from => 'AvgCost', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :qty_on_hand, :from => 'QtyOnHand', :as => Float
        xml_accessor :qty_on_purchase_order, :from => 'QtyOnPurchaseOrder', :as => Float
        xml_accessor :qty_on_sales_order, :from => 'QtyOnSalesOrder', :as => Float
        xml_accessor :reorder_point, :from => 'ReorderPoint', :as => Float
        xml_accessor :man_part_num, :from => 'ManPartNum'
        xml_accessor :print_grouped_items, :from => 'PrintGroupedItems'

        validates_length_of :name, :minimum => 1, :maximum => 31
        validates_length_of :desc, :minimum => 1, :maximum => 4000
        validates_inclusion_of :type, :in => ["Assembly", "Fixed Asset", "Group", "Inventory", "Other Charge", "Payment", "Product", "Service", "Subtotal"]
        validate :name_cannot_contain_invalid_characters
        # Note: You must also specify account references for create.  Which ones depends on the item type.
        # See: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0500_QuickBooks_Windows/0600_Object_Reference/Item

        def to_xml_ns(options = {})
          to_xml(options)
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
          errors.empty?
        end

        def valid_for_create?
          valid?
          errors.empty?
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

        def name_cannot_contain_invalid_characters
          if name.to_s.index(':')
            errors.add(:name, "Name cannot contain a colon (:)")
          end
        end

      end
    end
  end

end