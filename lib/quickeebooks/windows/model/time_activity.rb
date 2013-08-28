require "quickeebooks"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/address"
require "quickeebooks/windows/model/phone"
require "quickeebooks/windows/model/web_site"
require "quickeebooks/windows/model/email"
require "quickeebooks/windows/model/note"
require "quickeebooks/windows/model/custom_field"
require "quickeebooks/windows/model/time_activity_employee"
require "quickeebooks/windows/model/time_activity_vendor"


module Quickeebooks
  module Windows
    module Model
      class TimeActivity < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'TimeActivities'
        XML_NODE = 'TimeActivity'

        # https://services.intuit.com/sb/timeactivity/v2/<realmID>
        REST_RESOURCE = "timeactivity"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :txn_date, :from => 'TxnDate'
        xml_accessor :name_of, :from => 'NameOf'
        xml_accessor :employee, :from => 'Employee', :as => Quickeebooks::Windows::Model::TimeActivityEmployee
        xml_accessor :vendor, :from => 'Vendor', :as => Quickeebooks::Windows::Model::TimeActivityVendor
        xml_accessor :customer_id, :from => 'CustomerId'
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :job_id, :from => 'JobId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :job_name, :from => 'JobName'
        xml_accessor :item_id, :from => 'ItemId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :item_name, :from => 'ItemName'
        xml_accessor :item_type, :from => 'ItemType'
        xml_accessor :class_id, :from => 'ClassId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :pay_item_id, :from => 'PayItemId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :pay_item_name, :from => 'PayItemName'
        xml_accessor :billable_status, :from => 'BillableStatus'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :hourly_rate, :from => 'HourlyRate'
        xml_accessor :hours, :from => 'Hours'
        xml_accessor :minutes, :from => 'Minutes'
        xml_accessor :seconds, :from => 'Seconds'
        xml_accessor :break_hours, :from => 'BreakHours'
        xml_accessor :break_minutes, :from => 'BreakMinutes'
        xml_accessor :start_time, :from => 'StartTime'
        xml_accessor :end_time, :from => 'EndTime'
        xml_accessor :description, :from => 'Description'

        validates_inclusion_of :name_of, :in => %w(Employee Vendor)
        validates_inclusion_of :billable_status, :in => %w(Billable NotBillable HasBeenBilled),
          :allow_blank => true
        validate :duration_is_set

        def valid_for_create?
          valid?
          errors.empty?
        end

        def duration_is_set
          unless (self.hours || self.minutes || self.seconds)
            errors.add(:base, 'A duration is required')
          end
        end

      end
    end
  end
end
