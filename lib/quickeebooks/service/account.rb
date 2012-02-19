require 'quickeebooks/model/account'
require 'quickeebooks/service/service_base'

module Quickeebooks
  module Service
    class Account < ServiceBase
      
      def list(options = {})
        fetch_collection(:post, "accounts", "Account", Quickeebooks::Model::Account)
      end

      def create(account)
        raise InvalidModelException unless account.valid?
        xml = account.to_xml_ns
        do_http_post(url_for_resource("account"), valid_xml_document(xml))
      end

      def delete(account)
        raise InvalidModelException.new("Missing required parameters for delete") unless account.valid_for_deletion?
        xml = valid_xml_document(account.to_xml_ns(:fields => ['Id', 'SyncToken']))
        url = "#{url_for_resource("account")}/#{account.id}"
        do_http_post(url, xml, {:methodx => "delete"})
      end
      
    end
  end
end