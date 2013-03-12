require "quickeebooks"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/address"
require "quickeebooks/online/model/phone"
require "quickeebooks/online/model/web_site"
require "quickeebooks/online/model/email"
require "quickeebooks/online/model/open_balance"
require "quickeebooks/common/online_entity_model"

module Quickeebooks
  module Online
    module Model
      class Vendor < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineEntityModel
        
        XML_NODE = "Vendor"
        REST_RESOURCE = "vendor"

        xml_accessor :is_1099?, :from => 'Vendor1099'

      end
    end
  end
end
