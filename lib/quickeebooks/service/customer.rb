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
        do_http_post(url_for_resource("customer") + '/' + customer.id, xml, {:methodx => "delete"})
      end
      
      def list
        customers = []
        response = do_http_post(url_for_resource("customers"), "")
        if response
          xml = parse_xml(response)
          xml.xpath("//qbo:SearchResults/qbo:CdmCollections/xmlns:Customer").each do |xc|
            customers << Quickeebooks::Model::Customer.from_xml(xc)
          end
          customers
        else
          nil
        end
      end
      
    end
  end
end