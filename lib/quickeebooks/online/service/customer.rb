require 'quickeebooks/online/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Customer < ServiceBase

        def create(customer)
          raise InvalidModelException unless customer.valid?
          xml = customer.to_xml_ns
          response = do_http_post(url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Customer.from_xml(response.body)
          else
            nil
          end
        end

        def fetch_by_id(id)
          url = "#{url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/#{id}"
          response = do_http_get(url)
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::Customer.from_xml(response.body)
          else
            nil
          end
        end

        def update(customer)
          raise InvalidModelException.new("Missing required parameters for update") unless customer.valid_for_update?
          url = "#{url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/#{customer.id.value}"
          xml = customer.to_xml_ns
          response = do_http_post(url, valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Customer.from_xml(response.body)
          else
            nil
          end
        end

        def delete(customer)
          raise InvalidModelException.new("Missing required parameters for delete") unless customer.valid_for_deletion?
          xml = valid_xml_document(customer.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource(Quickeebooks::Online::Model::Customer.resource_for_singular)}/#{customer.id.value}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::Customer, filters, page, per_page, sort, options)
        end

      end
    end
  end
end