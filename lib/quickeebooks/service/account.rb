require 'quickeebooks/model/account'
require 'quickeebooks/service/service_base'

module Quickeebooks
  module Service
    class Account < ServiceBase
      
      def list(options = {})
        fetch_collection(:post, "accounts", "Account", Quickeebooks::Model::Account)
      end
      
      def delete(account)
      end
      
    end
  end
end