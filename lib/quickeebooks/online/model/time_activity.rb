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
        REST_RESOURCE = "time-activity"

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

        validates_inclusion_of :name_of, :in => %w(Employee Vendor)
        validate :has_vendor_node, :if => Proc.new { |c| c.name_of == 'Vendor' }
        validate :has_employee_node, :if => Proc.new { |c| c.name_of == 'Employee' }
        validates_presence_of :customer_id, :if => Proc.new { |c| c.billable_status == 'Billable' }
        validates_presence_of :hourly_rate, :if => Proc.new { |c| c.billable_status == 'Billable' }
        validates_inclusion_of :billable_status, :in => %w(Billable NotBillable HasBeenBilled),
          :allow_blank => true
        validate :duration_is_set

        def duration_is_set
          if (self.hours || self.minutes) && (self.start_time || self.end_time)
            errors.add(:base, 'Only one duration type allowed')
          end
          unless (self.hours || self.minutes) || (self.start_time && self.end_time)
            errors.add(:base, 'A duration is required')
          end
        end

        def has_vendor_node
          unless self.vendor.is_a?(Quickeebooks::Online::Model::TimeActivityVendor)
            errors.add(:vendor, "can't be blank")
          end
        end

        def has_employee_node
          unless self.vendor.is_a?(Quickeebooks::Online::Model::TimeActivityEmployee)
            errors.add(:employee, "can't be blank")
          end
        end

        def self.resource_for_collection
          'time-activities'
        end
      end
    end
  end
end
