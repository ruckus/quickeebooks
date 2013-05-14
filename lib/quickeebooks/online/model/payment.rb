require 'quickeebooks/online/model/payment_header'
require 'quickeebooks/online/model/payment_line_item'
require 'quickeebooks/online/model/payment_detail'
require 'quickeebooks/online/model/credit_card'
require 'quickeebooks/online/model/credit_charge_info'
require 'quickeebooks/online/model/credit_charge_response'
require 'quickeebooks/online/model/meta_data'
require 'quickeebooks/common/online_line_item_model_methods'

module Quickeebooks
  module Online
    module Model
      class Payment  < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineLineItemModelMethods

        XML_NODE = "Payment"
        REST_RESOURCE = "payment"

        xml_convention :camelcase
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header,     :from => 'Header',    :as => Quickeebooks::Online::Model::PaymentHeader
        xml_accessor :line_items, :from => 'Line',      :as => [Quickeebooks::Online::Model::PaymentLineItem]

      end
    end
  end
end
