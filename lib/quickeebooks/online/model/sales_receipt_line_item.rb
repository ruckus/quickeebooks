module Quickeebooks
  module Online
    module Model
      class SalesReceiptLineItem < Quickeebooks::Online::Model::IntuitType
        xml_name 'Line'
        xml_accessor :id,                         :from => 'Id',                      :as => Integer
        xml_accessor :desc,                       :from => 'Desc'
        xml_accessor :amount,                     :from => 'Amount',                  :as => Float
        xml_accessor :class_id,                   :from => 'ClassId',                 :as => Quickeebooks::Online::Model::Id
        xml_accessor :item_id,                    :from => 'ItemId',                  :as => Quickeebooks::Online::Model::Id
        xml_accessor :unit_price,                 :from => 'UnitPrice',               :as => Float
        xml_accessor :quantity,                   :from => 'Qty',                     :as => Float
        xml_accessor :override_item_account_id,   :from => 'OverrideItemAccountId',   :as => Quickeebooks::Online::Model::Id
      end
    end
  end
end
