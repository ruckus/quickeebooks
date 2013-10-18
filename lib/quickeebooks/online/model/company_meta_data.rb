# see https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/CompanyMetaData
require "quickeebooks"
require "quickeebooks/online/model/address"
require "quickeebooks/online/model/phone"
require "quickeebooks/online/model/email"

module Quickeebooks
  module Online
    module Model
      class CompanyMetaData < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        REST_RESOURCE = "companymetadata"

        xml_convention :camelcase
        xml_accessor :external_realm_id, :from => 'ExternalRealmId'
        xml_accessor :registered_company_name, :from => 'QBNRegisteredCompanyName'
        xml_accessor :industry_type, :from => 'IndustryType'
        xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Online::Model::Address]
        xml_accessor :legal_address, :from => 'LegalAddress', :as => Quickeebooks::Online::Model::Address
        xml_accessor :emails, :from => 'Email', :as => [Quickeebooks::Online::Model::Email]
        xml_accessor :phone, :from => 'Phone', :as => Quickeebooks::Online::Model::Phone

        def to_xml_ns(options = {})
          to_xml_inject_ns('CompanyMetaData', options)
        end
      end
    end
  end
end
