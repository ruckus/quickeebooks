require "quickeebooks"
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/account_detail_type"
require "quickeebooks/online/model/id"

module Quickeebooks
  module Online
    module Model
      class Account < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        REST_RESOURCE = "account"
        XML_NODE = "Account"

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :name, :from => 'Name'
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :sub_type, :from => 'Subtype'
        xml_accessor :type, :from => 'Type'
        xml_accessor :acct_num, :from => 'AcctNum'
        xml_accessor :account_parent_id, :from => 'AccountParentId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :current_balance, :from => 'CurrentBalance', :as => Float
        xml_accessor :opening_balance_date, :from => 'OpeningBalanceDate', :as => Date

        validates_presence_of :name, :sub_type
        validates_inclusion_of :sub_type, :in => Quickeebooks::Online::Model::AccountDetailType::TYPES

        def to_xml_ns(options = {})
          to_xml_inject_ns('Account', options)
        end

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

      end
    end

  end
end
