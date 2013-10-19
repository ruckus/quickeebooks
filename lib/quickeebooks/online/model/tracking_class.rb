# https://developer.intuit.com/docs/0025_intuit_anywhere/0050_data_services/v2/0400_quickbooks_online/class
require 'quickeebooks/online/model/meta_data'

module Quickeebooks
  module Online
    module Model
      class TrackingClass  < Quickeebooks::Online::Model::IntuitType
        XML_NODE = "Class"
        REST_RESOURCE = "class"

        include ActiveModel::Validations
        xml_name 'Class'
        xml_convention :camelcase
        xml_accessor :id,              :from => 'Id',            :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token,      :from => 'SyncToken',     :as => Integer
        xml_accessor :meta_data,       :from => 'MetaData',      :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :name,            :from => 'Name'
        xml_accessor :class_parent_id, :from => 'ClassParentId', :as => Quickeebooks::Online::Model::Id

        def to_xml_ns(options = {})
          to_xml_inject_ns(XML_NODE, options)
        end

        def valid_for_update?
          if sync_token.nil?
            errors.add(:sync_token, "Missing required attribute SyncToken for update")
          end
          valid?
          errors.empty?
        end

        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        def self.resource_for_collection
          REST_RESOURCE + "es"
        end
      end
    end
  end
end
