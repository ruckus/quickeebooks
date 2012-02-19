require 'rexml/document'
require 'uri'
require 'cgi'

class IntuitRequestException < Exception
  attr_accessor :code, :cause
  def initialize(msg)
    super(msg)
  end
end
class AuthorizationFailure < Exception; end

module Quickeebooks
  module Service
    class ServiceBase
      attr_accessor :realm_id
      attr_accessor :oauth
      attr_reader :base_uri
      
      QB_BASE_URI = "https://qbo.intuit.com/qbo1/rest/user/v2"
      XML_NS = 'xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://www.intuit.com/sb/cdm/v2"'
      
      def initialize(oauth_consumer_token, realm_id, base_url = nil)
        @oauth = oauth_consumer_token
        @realm_id = realm_id
        if base_url.nil?
          determine_base_url
        else
          uri = URI.parse(base_url)
          if uri.host.nil?
            raise ArgumentError, "#{base_url} doesn't appear to be a valid host name!"
          end
          @base_uri = base_url
        end
      end
      
      # Given a realm ID we need to determine the real Base URL
      # to use for all subsequenet REST operations
      # See: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL
      def determine_base_url
        response = @oauth.request(:get, qb_base_uri_with_realm_id)
        if response
          if response.code == "200"
            doc = parse_xml(response.body)
            element = doc.xpath("//qbo:QboUser/qbo:CurrentCompany/qbo:BaseURI")[0]
            if element
              @base_uri = element.text
            end
          else
            raise IntuitRequestException.new("Response error: invalid code #{response.code}")
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
      
      def parse_xml(xml)
        Nokogiri::XML(xml)
      end
      
      def valid_xml_document(xml)
        doc = <<-XML
        <?xml version="1.0" encoding="utf-8"?>
        #{xml}
        XML
        doc.strip
      end
      
      def fetch_collection(resource, container, model, filters = [], page = 1, per_page = 20, sort = nil, options ={})
        raise ArgumentError, "missing resource to fetch" if resource.nil?
        raise ArgumentError, "missing result container" if container.nil?
        raise ArgumentError, "missing model to instantiate" if model.nil?

        post_body_lines = []
        
        if filters.is_a?(Array) && filters.length > 0
          filter_string = filters.collect { |f| f.to_s }
          post_body_lines << "Filter=#{CGI.escape(filter_string.join(" :AND: "))}"
        end
        
        post_body_lines << "PageNum=#{page}"
        post_body_lines << "ResultsPerPage=#{per_page}"
        
        if sort
          post_body_lines << "Sort=#{CGI.escape(sort.to_s)}"
        end
        
        body = post_body_lines.join("&")
        response = do_http_post(url_for_resource(resource), body, {}, {'Content-Type' => 'application/x-www-form-urlencoded'})
        if response
          collection = Quickeebooks::Collection.new
          xml = parse_xml(response.body)
          begin
            results = []
            collection.count = xml.xpath("//qbo:SearchResults/qbo:Count")[0].text.to_i
            if collection.count > 0
              xml.xpath("//qbo:SearchResults/qbo:CdmCollections/xmlns:#{container}").each do |xa|
                results << model.from_xml(xa)
              end
            end
            collection.entries = results
            collection.current_page = xml.xpath("//qbo:SearchResults/qbo:CurrentPage")[0].text.to_i
          rescue => ex
            log("Error parsing XML: #{ex.message}")
            raise IntuitRequestException.new("Error parsing XML: #{ex.message}")
          end
          collection
        else
          nil
        end
      end

      def do_http_post(url, body = "", params = {}, headers = {}) # throws IntuitRequestException
        url = add_query_string_to_url(url, params)
        do_http(:post, url, body, headers)
      end

      def do_http_get(url, params = {}, headers = {}) # throws IntuitRequestException
        url = add_query_string_to_url(url, params)
        do_http(:get, url, "", headers)
      end

      def do_http(method, url, body, headers) # throws IntuitRequestException
        unless headers.has_key?('Content-Type')
          headers.merge!({'Content-Type' => 'application/xml'})
        end
        # puts "METHOD = #{method}"
        # puts "URL = #{url}"
        # puts "BODY = #{body == nil ? "<NIL>" : body}"
        # puts "HEADERS = #{headers.inspect}"
        response = @oauth.request(method, url, body, headers)
        check_response(response)
      end

      def add_query_string_to_url(url, params)
        if params.is_a?(Hash) && !params.empty?
          url + "?" + params.collect { |k| "#{k.first}=#{k.last}" }.join("&")
        else
          url
        end
      end

      def check_response(response)
        #puts "HTTP Response: #{response.code}"
        status = response.code.to_i
        case status
        when 200
          response
        when 302
          raise "Unhandled HTTP Redirect"
        when 401
          raise AuthorizationFailure
        when 400, 500
          err = parse_intuit_error(response.body)
          ex = IntuitRequestException.new(err[:message])
          ex.code = err[:code]
          ex.cause = err[:cause]
          raise ex
        else
          raise "HTTP Error Code: #{status}, Msg: #{response.body}"
        end
      end

      def parse_intuit_error(body)
        xml = parse_xml(body)
        error = {:message => "", :code => 0, :cause => ""}
        fault = xml.xpath("//xmlns:FaultInfo/xmlns:Message")[0]
        if fault
          error[:message] = fault.text
        end
        error_code = xml.xpath("//xmlns:FaultInfo/xmlns:ErrorCode")[0]
        if error_code
          error[:code] = error_code.text
        end
        error_cause = xml.xpath("//xmlns:FaultInfo/xmlns:Cause")[0]
        if error_cause
          error[:cause] = error_cause.text
        end

        error
      end

      def log(msg)
        Quickeebooks.logger.info(msg)
        Quickeebooks.logger.flush if Quickeebooks.logger.respond_to?(:flush)
      end

    end
  end
end