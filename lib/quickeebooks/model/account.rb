require "quickeebooks"
require "quickeebooks/model/meta_data"
require "quickeebooks/model/account_detail_type"

module Quickeebooks
  module Model
    class Account < IntuitType
      include ActiveModel::Validations
      xml_convention :camelcase
      xml_accessor :id, :from => 'Id'
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Model::MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :desc, :from => 'Desc'
      xml_accessor :sub_type, :from => 'Subtype'
      xml_accessor :acct_num, :from => 'AcctNum'
      xml_accessor :account_parent_id, :from => 'AccountParentId'
      xml_accessor :current_balance, :from => 'CurrentBalance', :as => Float
      xml_accessor :opening_balance_date, :from => 'OpeningBalanceDate', :as => Date

      validates_presence_of :name, :sub_type
      validates_inclusion_of :sub_type, :in => Quickeebooks::Model::AccountDetailType::TYPES

      def to_xml_ns(options = {})
        to_xml_inject_ns('Account', options)
      end
      
      # To delete an account Intuit requires we provide Id and SyncToken fields
      def valid_for_deletion?
        return false if(id.nil? || sync_token.nil?)
        id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
      end

    end
    
    
  end
end