require "quickeebooks"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/id"
require "quickeebooks/windows/model/custom_field"
require "quickeebooks/windows/model/meta_data"

module Quickeebooks
  module Windows
    module Model
      class Clazz < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Classes'
        XML_NODE = 'Class'

        # https://services.intuit.com/sb/customer/v2/<realmID>
        REST_RESOURCE = "class"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :object_state
        xml_accessor :name
        xml_accessor :active
        xml_accessor :class_parent_id, :from => 'ClassParentId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :class_parent_name, :from => 'ClassParentName'

        validates_length_of :name, :minimum => 1, :maximum => 256

        def active?
          active == 'true'
        end

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
          to_xml
        end

        # To delete an account Intuit requires we provide Id and SyncToken fields
        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

      end
    end
  end
end
