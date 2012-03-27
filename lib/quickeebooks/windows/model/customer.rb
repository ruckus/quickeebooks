require "quickeebooks"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/address"
require "quickeebooks/windows/model/phone"
require "quickeebooks/windows/model/web_site"
require "quickeebooks/windows/model/email"
require "quickeebooks/windows/model/note"
require "quickeebooks/windows/model/customer_custom_field"
require "quickeebooks/windows/model/open_balance"

module Quickeebooks
  module Windows
    module Model
      class Customer < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        DEFAULT_TYPE_OF = 'Person'
        XML_COLLECTION_NODE = 'Customers'
        XML_NODE = 'Customer'
        
        xml_convention :camelcase
        xml_accessor :id, :from => 'Id'
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :draft
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :party_reference_id, :from => 'PartyReferenceId'
        xml_accessor :type_of, :from => 'TypeOf'
        xml_accessor :name, :from => 'Name'
        xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Windows::Model::Address]
        xml_accessor :email, :from => 'Email', :as => Quickeebooks::Windows::Model::Email
        xml_accessor :phones, :from => 'Phone', :as => [Quickeebooks::Windows::Model::Phone]
        xml_accessor :web_site, :from => 'WebSite', :as => Quickeebooks::Windows::Model::WebSite
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
        xml_accessor :paymethod_method_id, :from => 'PaymentMethodId'
        xml_accessor :paymethod_method_name, :from => 'PaymentMethodName'
        xml_accessor :price_level_id, :from => 'PriceLevelId'
        xml_accessor :price_level_name, :from => 'PriceLevelName'
        xml_accessor :open_balance_date, :from => 'OpenBalanceDate', :as => Time
        xml_accessor :open_balance, :from => 'OpenBalance', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :open_balance_with_jobs, :from => 'OpenBalanceWithJobs', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :credit_limit, :from => 'CreditLimit', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :acct_num, :from => 'AcctNum'
        xml_accessor :over_due_balance, :from => 'OverDueBalance', :as => Quickeebooks::Windows::Model::Price
        xml_accessor :total_expense, :from => 'TotalExpense', :as => Quickeebooks::Windows::Model::Price

        validates_length_of :name, :minimum => 1
        validate :has_required_attributes
        
        def active?
          active == 'true'
        end
        
        def has_required_attributes
          if name.is_a?(String) && name.index(':') != nil
            errors.add(:name, "Attribute :name cannot contain a colon")
          end
        end
        
        def valid_for_update?
          if sync_token.nil?
            errors.add(:sync_token, "Missing required attribute SyncToken for update")
          end
          errors.empty?
        end

        def to_xml_ns(options = {})
          to_xml
        end

        def email_address=(email_address)
          self.email = Quickeebooks::Windows::Model::Email.new(email_address)
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
