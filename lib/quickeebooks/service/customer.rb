require 'quickeebooks/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Service
    class Customer < ServiceBase
      
      def create(customer)
        xml = customer.to_xml_ns
        do_http_post(url_for_resource("customer"), valid_xml_document(xml))
      end
      
      def fetch_by_id(id)
        body = do_http_get(url_for_resource("customer") + '/' + id)
        Quickeebooks::Model::Customer.from_xml(body)
      end
      
      def delete(customer)
        xml = valid_xml_document(customer.to_xml_ns(:fields => ['Id', 'SyncToken']))
        url = "#{url_for_resource("customer")}/#{customer.id}"
        do_http_post(url, xml, {:methodx => "delete"})
      end
      
      def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
        fetch_collection("customers", "Customer", Quickeebooks::Model::Customer, filters, page, per_page, sort, options)
      end
      
    end
  end
end