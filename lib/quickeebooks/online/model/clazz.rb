require "quickeebooks"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"

module Quickeebooks
  module Online
    module Model
      class Clazz < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Classes'
        XML_NODE = 'Class'

        # https://developer.intuit.com/docs/0025_quickbooksapi/0050_data_services/v2/0400_quickbooks_online/class
        REST_RESOURCE = "class"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :name
        xml_accessor :class_parent_id, :from => 'ClassParentId', :as => Quickeebooks::Online::Model::Id

        validates_length_of :name, :minimum => 1, :maximum => 256

        def valid_for_update?
          if sync_token.nil?
            errors.add(:sync_token, "Missing required attribute SyncToken for update")
          end
          errors.empty?
        end

        def valid_for_create?
          valid?
          if type_of.nil?
            errors.add(:type_of, "Missing required attribute TypeOf for Create")
          end
          errors.empty?
        end

        def to_xml_ns(options = {})
          options.merge!(:destination_name => 'Class')
          to_xml_inject_ns('Clazz', options)
        end

        # To delete an account Intuit requires we provide Id and SyncToken fields
        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        def self.resource_for_collection
          "classes"
        end

      end
    end
  end
end
