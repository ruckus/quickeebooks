require 'quickeebooks/model/account'
require 'quickeebooks/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Service
    class Account < ServiceBase
      
      def list(options = {})
        fetch_collection(:post, "accounts", "Account", Quickeebooks::Model::Account)
      end
      
      def delete(account)
        url = "#{url_for_resource("account")}/#{account.id}?methodx=delete"
        do_http_post(url)
      end
      
    end
  end
end