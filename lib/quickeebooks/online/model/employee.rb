require "quickeebooks"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/address"
require "quickeebooks/online/model/phone"
require "quickeebooks/online/model/web_site"
require "quickeebooks/online/model/email"
require "quickeebooks/common/online_entity_model"

module Quickeebooks
  module Online
    module Model
      class Employee < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineEntityModel
        include Quickeebooks::Model::Addressable

        XML_NODE = "Employee"
        REST_RESOURCE = "employee"

        #xml_accessor :is_1099?, :from => 'Vendor1099'

      end
    end
  end
end
