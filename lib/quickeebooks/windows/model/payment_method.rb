module Quickeebooks
  module Windows
    module Model
      class PaymentMethod  < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'PaymentMethods'
        XML_NODE = 'PaymentMethod'

        # https://services.intuit.com/sb/paymentmethod/v2/<realmID>
        REST_RESOURCE = "paymentmethod"

        xml_name 'PaymentMethod'
        xml_convention :camelcase
        xml_accessor :id,             :from => 'Id',            :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token,     :from => 'SyncToken',     :as => Integer
        xml_accessor :meta_data,      :from => 'MetaData',      :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key,   :from => 'ExternalKey'
        xml_accessor :custom_fields,  :from => 'CustomField',   :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :name,           :from => 'Name'
        xml_accessor :active,         :from => 'Active'
        xml_accessor :type,           :from => 'Type'

        validates_length_of :name, :minimum => 1
      end
    end
  end
end
