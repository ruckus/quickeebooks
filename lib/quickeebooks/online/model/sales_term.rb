# see https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/CompanyMetaData
require "quickeebooks"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/id"

module Quickeebooks
  module Online
    module Model
      class SalesTerm < Quickeebooks::Online::Model::IntuitType

        include ActiveModel::Validations
        include OnlineEntityModel

        XML_NODE = "SalesTerm"
        REST_RESOURCE = "sales-term"

        xml_accessor :due_days, :from => 'DueDays', :as => Integer
        xml_accessor :discount_days, :from => 'DiscountDays'
        xml_accessor :discount_precent, :from => 'DiscountPercent', :as => Float
        xml_accessor :day_of_monthe_due, :from => 'DayOfMonthDue', :as => Integer
        xml_accessor :due_next_month_days, :from => 'DueNextMonthDays', :as => Integer
        xml_accessor :discount_day_of_month, :from => 'DiscountDayOfMonth', :as => Integer
        xml_accessor :date_discount_percent, :from => 'DateDiscountPercent', :as => Float

        validates_length_of :name, :minimum => 1


        def to_xml_ns(options = {})
          to_xml_inject_ns('SalesTerm', options)
        end
      end
    end
  end
end
