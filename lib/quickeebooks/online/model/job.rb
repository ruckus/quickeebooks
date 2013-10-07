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
      class Job < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineEntityModel
        include Quickeebooks::Model::Addressable

        XML_NODE = "Job"
        REST_RESOURCE = "job"

        xml_accessor :notes, :from => 'Notes', :as => [Quickeebooks::Online::Model::Note]
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Online::Model::CustomerCustomField]
        xml_accessor :paymethod_method_id, :from => 'PaymentMethodId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :payment_method_name, :from => 'PaymentMethodName'
        xml_accessor :customer_id, :from => 'CustomerId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :job_parent_id, :from => 'JobParentId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :job_parent_name, :from => 'JobParentName'

        validates_length_of :name, :minimum => 1
        validate :require_a_customer
        
        private
        
        def require_a_customer
          if customer_id.nil?
            errors.add(:customer_id, "Must provide a Customer ID.")
          end
        end

      end
    end
  end
end
