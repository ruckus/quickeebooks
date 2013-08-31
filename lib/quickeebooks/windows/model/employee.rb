require "quickeebooks"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/address"
require "quickeebooks/windows/model/phone"
require "quickeebooks/windows/model/web_site"
require "quickeebooks/windows/model/email"
require "quickeebooks/windows/model/note"
require "quickeebooks/windows/model/custom_field"


module Quickeebooks
  module Windows
    module Model
      class Employee < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Employees'
        XML_NODE = 'Employee'

        # https://services.intuit.com/sb/employee/v2/<realmID>
        REST_RESOURCE = "employee"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :party_reference_id, :from => 'PartyReferenceId'
        xml_accessor :type_of, :from => 'TypeOf'
        xml_accessor :name, :from => 'Name'
        xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Windows::Model::Address]
        xml_accessor :phone, :from => 'Phone', :as => Quickeebooks::Windows::Model::Phone
        xml_accessor :web_site, :from => 'WebSite', :as => Quickeebooks::Windows::Model::WebSite
        xml_accessor :email, :from => 'Email', :as => Quickeebooks::Windows::Model::Email
        xml_accessor :title, :from => 'Title'
        xml_accessor :given_name, :from => 'GivenName'
        xml_accessor :middle_name, :from => 'MiddleName'
        xml_accessor :family_name, :from => 'FamilyName'
        xml_accessor :suffix, :from => 'Suffix'
        xml_accessor :gender, :from => 'Gender'
        xml_accessor :dba_name, :from => 'DBAName'
        xml_accessor :tax_identifier, :from => 'TaxIdentifier'
        xml_accessor :notes, :from => 'Note', :as => [Quickeebooks::Windows::Model::Note]
        xml_accessor :active, :from => 'Active'
        xml_accessor :show_as, :from => 'ShowAs'
        xml_accessor :employee_type, :from => 'EmployeeType'
        xml_accessor :hired_date, :from => 'HiredDate'
        xml_accessor :released_date, :from => 'ReleasedDate'
        xml_accessor :use_time_entry, :from => 'UseTimeEntry'

        validates_length_of :name, :minimum => 1
        validate :name_cannot_contain_invalid_characters

        def valid_for_create?
          valid?
          if type_of.nil?
            errors.add(:type_of, "Missing required attribute TypeOf for Create")
          end
          errors.empty?
        end

        def name_cannot_contain_invalid_characters
          if name.to_s.index(':')
            errors.add(:name, "Name cannot contain a colon (:)")
          end
        end

        def address=(address)
          self.addresses ||= []
          self.addresses << address
        end

        def billing_address
            addresses.detect { |address| address.tag == "Billing" }
        end

        def shipping_address
            addresses.detect { |address| address.tag == "Shipping" }
        end

      end
    end
  end
end
