# http://docs.developer.intuit.com/0025_Intuit_Anywhere/0050_Data_Services/v2/0400_QuickBooks_Online/Bill
require 'quickeebooks/online/model/bill_header'
require 'quickeebooks/online/model/bill_line_item'
require 'quickeebooks/online/model/meta_data'
require 'quickeebooks/common/online_line_item_model_methods'

module Quickeebooks
  module Online
    module Model
      class Bill < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineLineItemModelMethods
        XML_NODE = "Bill"
        REST_RESOURCE = "bill"

        xml_convention :camelcase
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header,     :from => 'Header',    :as => Quickeebooks::Online::Model::BillHeader
        xml_accessor :line_items, :from => 'Line',      :as => [Quickeebooks::Online::Model::BillLineItem]

      end
    end
  end
end
