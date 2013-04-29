require "quickeebooks"
require "quickeebooks/online/model/id"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/time_activity_employee"
require "quickeebooks/online/model/time_activity_vendor"

module Quickeebooks
  module Online
    module Model
      class TimeActivity < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineEntityModel

        XML_NODE = "TimeActivity"
        REST_RESOURCE = "time_activity"

        xml_accessor :txn_date, :from => 'TxnDate'
        xml_accessor :name_of, :from => 'NameOf'

        xml_accessor :employee, :from => 'Employee', :as => Quickeebooks::Online::Model::TimeActivityEmployee
        xml_accessor :vendor, :from => 'Vendor', :as => Quickeebooks::Online::Model::TimeActivityVendor

        xml_accessor :customer_id, :from => 'CustomerId'
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :item_id, :from => 'ItemId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :class_id, :from => 'ClassId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :billable_status, :from => 'BillableStatus'
        xml_accessor :taxable, :from => 'Taxable'
        xml_accessor :hourly_rate, :from => 'HourlyRate'
        xml_accessor :hours, :from => 'Hours', :as => Integer
        xml_accessor :minutes, :from => 'Minutes', :as => Integer
        xml_accessor :seconds, :from => 'Seconds', :as => Integer
        xml_accessor :break_hours, :from => 'BreakHours', :as => Integer
        xml_accessor :break_minutes, :from => 'BreakMinutes', :as => Integer
        xml_accessor :start_time, :from => 'StartTime', :as => DateTime
        xml_accessor :end_time, :from => 'EndTime', :as => DateTime
        xml_accessor :description, :from => 'Description'

        validates_presence_of :name_of, :customer_id, :hourly_rate


        def self.resource_for_collection
          'time-activities'
        end
      end
    end
  end
end
