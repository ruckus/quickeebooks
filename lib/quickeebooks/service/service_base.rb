require 'rexml/document'

module Quickeebooks
  module Service
    class ServiceBase
      attr_accessor :realm_id
      attr_accessor :oauth_consumer
      attr_reader :base_uri
      
      QB_BASE_URI = "https://qbo.intuit.com/qbo1/rest/user/v2"
      
      def initialize(oauth_consumer, realm_id)
        @oauth_consumer = oauth_consumer
        @realm_id = realm_id
        
        determine_base_url
      end
      
      # Given a realm ID we need to determine the real Base URL
      # to use for all subsequenet REST operations
      # See: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL
      def determine_base_url
        response = @oauth_consumer.request(:get, qb_base_uri_with_realm_id)
        if response
          if response.code == "200"
            doc = REXML::Document.new(response.body)
            base = doc.elements['qbo:QboUser/qbo:CurrentCompany/qbo:BaseURI']
            if base
              @base_uri = base.text
            end
          else
            raise "Response error: invalid code #{response.code}"
          end
        end
      end
      
      private
      
      def base_uri_with_realm_id
        raise "Base URI has not been determined" if @base_uri.nil?
        "#{@base_uri}/#{@realm_id}"
      end

      def qb_base_uri_with_realm_id
        "#{QB_BASE_URI}/#{@realm_id}"
      end

    end
  end
end