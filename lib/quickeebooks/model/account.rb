module Quickeebooks

  class Account < IntuitType
    xml_accessor :id, :from => 'Id'
    xml_accessor :syncToken, :from => 'SyncToken', :as => Integer
    xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Model::MetaData
    xml_accessor :name, :from => 'Name'
    xml_accessor :desc, :from => 'Desc'
    xml_accessor :sub_type, :from => 'Subtype'
    xml_accessor :acct_num, :from => 'AcctNum'
    xml_accessor :account_parent_id, :from => 'AccountParentId'
    xml_accessor :current_balance, :from => 'CurrentBalance', :as => Float
  end
end