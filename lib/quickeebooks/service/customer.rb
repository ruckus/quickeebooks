require 'quickeebooks/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Service
    class Customer < ServiceBase

      def create(customer)
        raise InvalidModelException unless customer.valid?
        xml = customer.to_xml_ns
        response = do_http_post(url_for_resource("customer"), valid_xml_document(xml))
        if response.code.to_i == 200
          Quickeebooks::Model::Customer.from_xml(response.body)
        else
          nil
        end
      end

      def fetch_by_id(id)
        url = "#{url_for_resource("customer")}/#{id}"
        response = do_http_get(url)
        if response && response.code.to_i == 200
          Quickeebooks::Model::Customer.from_xml(response.body)
        else
          nil
        end
      end
      
      def update(customer)
        raise InvalidModelException.new("Missing required parameters for update") unless customer.valid_for_update?
        url = "#{url_for_resource("customer")}/#{customer.id}"
        xml = customer.to_xml_ns
        response = do_http_post(url, valid_xml_document(xml))
        if response.code.to_i == 200
          Quickeebooks::Model::Customer.from_xml(response.body)
        else
          nil
        end
      end

      def delete(customer)
        raise InvalidModelException.new("Missing required parameters for delete") unless customer.valid_for_deletion?
        xml = valid_xml_document(customer.to_xml_ns(:fields => ['Id', 'SyncToken']))
        url = "#{url_for_resource("customer")}/#{customer.id}"
        response = do_http_post(url, xml, {:methodx => "delete"})
        response.code.to_i == 200
      end

      def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
        fetch_collection("customers", "Customer", Quickeebooks::Model::Customer, filters, page, per_page, sort, options)
      end

    end
  end
end