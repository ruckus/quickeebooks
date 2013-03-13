require 'quickeebooks/online/model/account'
require 'quickeebooks/online/service/service_base'

module Quickeebooks
  module Online
    module Service
      class Account < ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::Account, filters, page, per_page, sort, options)
        end

        def create(account)
          raise InvalidModelException.new(account.errors.full_messages.join(", ")) unless account.valid?
          xml = account.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular), valid_xml_document(xml))
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::Account.from_xml(response.body)
          else
            nil
          end
        end

        def update(account)
          raise InvalidModelException unless account.valid_for_update?
          xml = account.to_xml_ns
          url = "#{url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular)}/#{account.id}"
          response = do_http_post(url, valid_xml_document(xml))
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::Account.from_xml(response.body)
          else
            nil
          end
        end

        def fetch_by_id(account_id)
          response = do_http_get("#{url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular)}/#{account_id}")
          Quickeebooks::Online::Model::Account.from_xml(response.body)
        end

        def delete(account)
          raise InvalidModelException.new("Missing required parameters for delete") unless account.valid_for_deletion?
          xml = valid_xml_document(account.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource(Quickeebooks::Online::Model::Account.resource_for_singular)}/#{account.id}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

      end
    end
  end
end