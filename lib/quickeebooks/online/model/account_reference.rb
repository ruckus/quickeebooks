require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class AccountReference < Quickeebooks::Online::Model::IntuitType
        xml_accessor :account_id, :from => 'AccountId'

        def initialize(account_id = nil)
          unless account_id.nil?
            self.account_id = account_id
          end
        end
      end
    end
  end
end
