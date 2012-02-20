require 'quickeebooks/model/account'
require 'quickeebooks/service/service_base'

module Quickeebooks
  module Service
    class Account < ServiceBase
      
      def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
        fetch_collection("accounts", "Account", Quickeebooks::Model::Account, filters, page, per_page, sort, options)
      end

      def create(account)
        raise InvalidModelException unless account.valid?
        xml = account.to_xml_ns
        response = do_http_post(url_for_resource("account"), valid_xml_document(xml))
        if response && response.code.to_i == 200
          Quickeebooks::Model::Account.from_xml(response.body)
        else
          nil
        end
      end
      
      def update(account)
        raise InvalidModelException unless account.valid_for_update?
        xml = account.to_xml_ns
        url = "#{url_for_resource("account")}/#{account.id}"
        response = do_http_post(url, valid_xml_document(xml))
        if response && response.code.to_i == 200
          Quickeebooks::Model::Account.from_xml(response.body)
        else
          nil
        end
      end
      
      def fetch_by_id(account_id)
        response = do_http_get("#{url_for_resource("account")}/#{account_id}")
        Quickeebooks::Model::Account.from_xml(response.body)
      end

      def delete(account)
        raise InvalidModelException.new("Missing required parameters for delete") unless account.valid_for_deletion?
        xml = valid_xml_document(account.to_xml_ns(:fields => ['Id', 'SyncToken']))
        url = "#{url_for_resource("account")}/#{account.id}"
        response = do_http_post(url, xml, {:methodx => "delete"})
        response.code.to_i == 200
      end
      
    end
  end
end