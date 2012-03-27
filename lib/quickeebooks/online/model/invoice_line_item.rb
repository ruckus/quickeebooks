module Quickeebooks

  module Online
    module Model
      class InvoiceLineItem < Quickeebooks::Online::Model::IntuitType
        xml_name 'Line'
        xml_accessor :id, :from => 'Id'
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :amount, :from => 'Amount', :as => Float
        xml_accessor :class_id, :from => 'ClassId'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :item_id, :from => 'ItemId'
        xml_accessor :unit_price, :from => 'UnitPrice', :as => Float
        xml_accessor :quantity, :from => 'Qty', :as => Float
        xml_accessor :override_item_account_id, :from => 'OverrideItemAccountId'
        xml_accessor :sales_tax_code_id, :from => 'SalesTaxCodeId'
        xml_accessor :sales_tax_code_name, :from => 'SalesTaxCodeName'
        xml_accessor :service_date, :from => 'ServiceDate', :as => Time
      end
    end
  end
end