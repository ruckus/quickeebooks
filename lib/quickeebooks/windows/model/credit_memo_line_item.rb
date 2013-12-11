module Quickeebooks
  module Windows
    module Model
      class CreditMemoLineItem < Quickeebooks::Windows::Model::IntuitType
        xml_name 'Line'
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :group_member, :from => 'GroupMember'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :amount, :from => 'Amount', :as => Float
        xml_accessor :class_id, :from => 'ClassId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :class_name, :from => 'ClassName'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :item_id, :from => 'ItemId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :item_name, :from => 'ItemName'
        xml_accessor :item_type, :from => 'ItemType'
        xml_accessor :unit_price, :from => 'UnitPrice', :as => Float
        xml_accessor :rate_percent, :from => 'RatePercent', :as => Float
        xml_accessor :price_level_id, :from => 'PriceLevelId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :price_level_name, :from => 'PriceLevelName'
        xml_accessor :uom_id, :from => 'UOMId'
        xml_accessor :uom_abbrev, :from => 'UOMAbbrv'
        xml_accessor :override_item_account_id, :from => 'OverrideItemAccountId'
        xml_accessor :override_item_account_name, :from => 'OverrideItemAccountName'
        xml_accessor :discount_id, :from => 'DiscountId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :discount_name, :from => 'DiscountName'
        xml_accessor :quantity, :from => 'Qty', :as => Float
        xml_accessor :sales_tax_code_id, :from => 'SalesTaxCodeId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sales_tax_code_name, :from => 'SalesTaxCodeName'
        xml_accessor :service_date, :from => 'ServiceDate', :as => Time
        xml_accessor :custom1, :from => 'Custom1'
        xml_accessor :custom2, :from => 'Custom2'
        xml_accessor :txn_id, :from => 'TxnId'
        xml_accessor :txn_line_id, :from => 'TxnLineId', :as => Quickeebooks::Windows::Model::Id
      end
    end
  end
end
