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
        validates_length_of :name, :minimum => 1

      end
    end
  end
end
