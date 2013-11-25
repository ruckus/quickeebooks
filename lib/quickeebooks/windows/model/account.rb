require "quickeebooks"
require "quickeebooks/windows/model/meta_data"
require "quickeebooks/windows/model/account_detail_type"

module Quickeebooks
  module Windows
    module Model
      class Account < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Accounts'
        XML_NODE = 'Account'

        # https://services.intuit.com/sb/account/v2/<realmID>
        REST_RESOURCE = "account"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :draft
        xml_accessor :object_state, :from => 'ObjectState'
        xml_accessor :account_parent_id, :from => 'AccountParentId'
        xml_accessor :account_parent_name, :from => 'AccountParentName'
        xml_accessor :name, :from => 'Name'
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :active
        xml_accessor :type, :from => 'Type'
        xml_accessor :sub_type, :from => 'SubType'
        xml_accessor :acct_num, :from => 'AcctNum'
        xml_accessor :bank_num, :from => 'BankNum'
        xml_accessor :routing_num, :from => 'RoutingNum'
        xml_accessor :opening_balance, :from => 'OpeningBalance', :as => Float
        xml_accessor :current_balance, :from => 'CurrentBalance', :as => Float
        xml_accessor :opening_balance_date, :from => 'OpeningBalanceDate', :as => Date
        xml_accessor :current_balance_with_sub_accounts, :from => 'CurrentBalanceWithSubAccounts', :as => Float

        validates_presence_of :name, :sub_type
        validates_inclusion_of :sub_type, :in => Quickeebooks::Windows::Model::AccountDetailType::TYPES
        validate :ensure_name_is_valid

        def valid_for_update?
          if sync_token.nil?
            errors.add(:sync_token, "Missing required attribute SyncToken for update")
          end
          valid?
          errors.empty?
        end

        # To delete an account Intuit requires we provide Id and SyncToken fields
        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end

        private

        def ensure_name_is_valid
          if name.nil?
            errors.add(:name, "Missing required attribute: name")
          end
          if name.is_a?(String) && name.index(':') != nil
            errors.add(:name, "Attribute :name cannot contain a colon")
          end
        end

      end

    end
  end
end
