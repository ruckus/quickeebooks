require 'quickeebooks/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Service
    class Customer < ServiceBase
      
      def list
        customers = []
        response = @oauth_consumer.request(:post, url_for_resource("customers"))
        if response && response.code == "200"
          xml = Nokogiri::XML(response.body)
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