require "quickeebooks"
require "quickeebooks/model/meta_data"

module Quickeebooks
  module Model
    class Account < IntuitType
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

      def to_xml_ns
        to_xml_inject_ns('Account')
      end

    end
  end
end