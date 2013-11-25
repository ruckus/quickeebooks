require "quickeebooks"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/custom_field"
require "quickeebooks/windows/model/address"
require "quickeebooks/windows/model/phone"
require "quickeebooks/windows/model/web_site"
require "quickeebooks/windows/model/email"
require "quickeebooks/windows/model/note"
require "quickeebooks/windows/model/purchase_cost"
require "quickeebooks/windows/model/job_job_info"

module Quickeebooks
  module Windows
    module Model
      class Job < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Jobs'
        XML_NODE = 'Job'

        # https://services.intuit.com/sb/job/v2/<realmId>

        REST_RESOURCE = "job"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :party_reference_id, :from => 'PartyReferenceId'
        xml_accessor :type_of, :from => 'TypeOf'
        xml_accessor :name, :from => 'Name'
        xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Windows::Model::Address]
        xml_accessor :phone, :from => 'Phone', :as => [Quickeebooks::Windows::Model::Phone]
        xml_accessor :web_site, :from => 'WebSite', :as => Quickeebooks::Windows::Model::WebSite
        xml_accessor :email, :from => 'Email', :as => Quickeebooks::Windows::Model::Email
        xml_accessor :external_id, :from => 'ExternalId'
        xml_accessor :title, :from => 'Title'
        xml_accessor :given_name, :from => 'GivenName'
        xml_accessor :middle_name, :from => 'MiddleName'
        xml_accessor :family_name, :from => 'FamilyName'
        xml_accessor :dba_name, :from => 'DBAName'
        xml_accessor :tax_identifier, :from => 'TaxIdentifier'
        xml_accessor :notes, :from => 'Note', :as => [Quickeebooks::Windows::Model::Note]
        xml_accessor :active, :from => 'Active'
        xml_accessor :show_as, :from => 'ShowAs'
        xml_accessor :customer_type_id, :from => 'CustomerTypeId'
        xml_accessor :customer_type_name, :from => 'CustomerTypeName'
        xml_accessor :sales_term_id, :from => 'SalesTermId'
        xml_accessor :sales_term_name, :from => 'SalesTermName'
        xml_accessor :sales_rep_id, :from => 'SalesRepId'
        xml_accessor :sales_rep_name, :from => 'SalesRepName'
        xml_accessor :sales_tax_code_id, :from => 'SalesTaxCodeId'
        xml_accessor :sales_tax_code_name, :from => 'SalesTaxCodeName'
        xml_accessor :tax_id, :from => 'TaxId'
        xml_accessor :tax_name, :from => 'TaxName'
        xml_accessor :tax_group_id, :from => 'TaxGroupId'
        xml_accessor :tax_group_name, :from => 'TaxGroupName'
        xml_accessor :payment_method_id, :from => 'PaymentMethodId'
        xml_accessor :payment_method_name, :from => 'PaymentMethodName'
        xml_accessor :price_level_id, :from => 'PriceLevelId'
        xml_accessor :price_level_name, :from => 'PriceLevelName'
        xml_accessor :open_balance_date, :from => 'OpenBalanceDate'
        xml_accessor :open_balance_with_jobs, :from => 'OpenBalanceWithJobs', :as => Quickeebooks::Windows::Model::PurchaseCost
        xml_accessor :credit_limit, :from => 'CreditLimit', :as => Quickeebooks::Windows::Model::PurchaseCost
        xml_accessor :acct_num, :from => 'AcctNum'
        xml_accessor :over_due_balance, :from => 'OverDueBalance', :as => Quickeebooks::Windows::Model::PurchaseCost
        xml_accessor :total_revenue, :from => 'TotalRevenue', :as => Quickeebooks::Windows::Model::PurchaseCost
        xml_accessor :total_expense, :from => 'TotalExpense', :as => Quickeebooks::Windows::Model::PurchaseCost
        xml_accessor :job_info, :from => 'JobInfo', :as => Quickeebooks::Windows::Model::JobJobInfo
        xml_accessor :customer_id, :from => 'CustomerId'
        xml_accessor :customer_name, :from => 'CustomerName'
        xml_accessor :job_parent_id, :from => 'JobParentId'
        xml_accessor :job_parent_name, :from => 'JobParentName'

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
