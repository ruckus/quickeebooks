# https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/v2/0400_quickbooks_online/billpayment
require 'quickeebooks/online/model/bill_payment_header'
require 'quickeebooks/online/model/bill_payment_line_item'
require 'quickeebooks/online/model/meta_data'
require 'quickeebooks/common/online_line_item_model_methods'

module Quickeebooks
  module Online
    module Model
      class BillPayment < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineLineItemModelMethods
        XML_NODE = "BillPayment"
        REST_RESOURCE = "bill-payment"

        xml_convention :camelcase
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header,     :from => 'Header',    :as => Quickeebooks::Online::Model::BillPaymentHeader
        xml_accessor :line_items, :from => 'Line',      :as => [Quickeebooks::Online::Model::BillPaymentLineItem]

      end
    end
  end
end
