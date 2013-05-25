require "quickeebooks"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/address"
require "quickeebooks/online/model/phone"
require "quickeebooks/online/model/web_site"
require "quickeebooks/online/model/email"
require "quickeebooks/online/model/note"
require "quickeebooks/online/model/customer_custom_field"
require "quickeebooks/online/model/open_balance"
require "quickeebooks/common/online_entity_model"

module Quickeebooks
  module Online
    module Model
      class Customer < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineEntityModel
        include Quickeebooks::Model::Addressable

        XML_NODE = "Customer"
        REST_RESOURCE = "customer"

        xml_accessor :notes, :from => 'Notes', :as => [Quickeebooks::Online::Model::Note]
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Online::Model::CustomerCustomField]
        xml_accessor :paymethod_method_id, :from => 'PaymentMethodId', :as => Quickeebooks::Online::Model::Id

        validates_length_of :name, :minimum => 1

      end
    end
  end
end
