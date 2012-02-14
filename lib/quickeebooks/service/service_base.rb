require 'rexml/document'

module Quickeebooks
  module Service
    class ServiceBase
      attr_accessor :realm_id
      attr_accessor :oauth_consumer
      attr_reader :base_uri
      
      QB_BASE_URI = "https://qbo.intuit.com/qbo1/rest/user/v2"
      
      def initialize(oauth_consumer, realm_id, base_url = nil)
        @oauth_consumer = oauth_consumer
        @realm_id = realm_id
        if base_url.nil?
          determine_base_url
        else
          @base_uri = base_url
        end
      end
      
      # Given a realm ID we need to determine the real Base URL
      # to use for all subsequenet REST operations
      # See: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL
      def determine_base_url
        response = @oauth_consumer.request(:get, qb_base_uri_with_realm_id)
        if response
          if response.code == "200"
            doc = Nokogiri::XML(response.body)
            element = doc.xpath("//qbo:QboUser/qbo:CurrentCompany/qbo:BaseURI")[0]
            if element
              @base_uri = element.text
            end
          else
            raise "Response error: invalid code #{response.code}"
          end
        end
      end

      def url_for_resource(resource)
        "#{@base_uri}/resource/#{resource}/v2/#{@realm_id}"
      end

      def qb_base_uri_with_realm_id
        "#{QB_BASE_URI}/#{@realm_id}"
      end

      private
      
      def fetch_collection(http_method = :post, resource = nil, container = nil, model = nil, options = {})
        results = []
        response = @oauth_consumer.request(http_method, url_for_resource(resource), nil, {'Content-Type' => 'application/x-www-form-urlencoded'})
        if response && response.code == "200"
          xml = Nokogiri::XML(response.body)
          xml.xpath("//qbo:SearchResults/qbo:CdmCollections/xmlns:#{container}").each do |xa|
            results << model.from_xml(xa)
          end
          results
        else
          nil
        end
      end

      def log(msg)
        Quickeebooks.logger.info(msg)
        Quickeebooks.logger.flush if Quickeebooks.logger.respond_to?(:flush)
      end

    end
  end
end