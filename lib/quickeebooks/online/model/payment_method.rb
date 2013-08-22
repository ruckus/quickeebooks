module Quickeebooks
  module Online
    module Model
      class PaymentMethod  < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'PaymentMethods'
        XML_NODE = 'PaymentMethod'

        # https://qbo.sbfinance.intuit.com/resource/payment-methods/v2/<realmID>
        REST_RESOURCE = "payment-method"

        xml_name 'PaymentMethod'
        xml_convention :camelcase
        xml_accessor :id,             :from => 'Id',            :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token,     :from => 'SyncToken',     :as => Integer
        xml_accessor :meta_data,      :from => 'MetaData',      :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :external_key,   :from => 'ExternalKey'
        xml_accessor :name,           :from => 'Name'
        xml_accessor :active,         :from => 'Active'
        xml_accessor :type,           :from => 'Type'

        validates_length_of :name, :minimum => 1
      end
    end
  end
end
