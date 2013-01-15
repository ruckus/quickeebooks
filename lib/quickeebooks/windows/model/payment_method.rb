require 'quickeebooks/windows/model/meta_data'

module Quickeebooks
  module Windows
    module Model
      class PaymentMethod  < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'PaymentMethods'
        XML_NODE = "PaymentMethod"
        REST_RESOURCE = "paymentmethod"

        xml_convention :camelcase
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :name,       :from => 'Name'

      end
    end
  end
end
