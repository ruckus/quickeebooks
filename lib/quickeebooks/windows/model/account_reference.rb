require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class AccountReference < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :account_id, :from => 'AccountId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :account_name, :from => 'AccountName'
        xml_accessor :account_type, :from => 'AccountType'

        def initialize(account_id = nil, account_name = nil)
          unless account_id.nil?
            self.account_id = account_id
          end

          unless account_name.nil?
            self.account_name = account_name
          end
        end
      end
    end
  end
end
