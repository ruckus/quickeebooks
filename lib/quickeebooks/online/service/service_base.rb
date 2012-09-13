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
  module Online

    module Service
      class ServiceBase
        attr_accessor :realm_id
        attr_accessor :oauth
        attr_accessor :base_uri

        QB_BASE_URI = "https://qbo.intuit.com/qbo1/rest/user/v2"
        XML_NS = %{xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:ns3="http://www.intuit.com/sb/cdm"}

        def initialize(oauth_access_token = nil, realm_id = nil)
          if !oauth_access_token.nil? && !realm_id.nil?
            msg = "Quickeebooks::Online::ServiceBase - "
            msg += "This version of the constructor is deprecated. "
            msg += "Use the no-arg constructor and set the AccessToken and the RealmID using the accessors."
            warn(msg)
            access_token = oauth_access_token
            realm_id = realm_id
          end
        end

        def access_token=(token)
          @oauth = token
        end
        
        def realm_id=(realm_id)
          @realm_id = realm_id
        end
        
        # uri is of the form `https://qbo.intuit.com/qbo36`
        def base_url=(uri)
          @base_uri = uri
        end

        # Given a realm ID we need to determine the real Base URL
        # to use for all subsequenet REST operations
        # See: https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/0100_Calling_Data_Services/0010_Getting_the_Base_URL
        def determine_base_url
          if service_response
            if service_response.code == "200"
              element = base_doc.xpath("//qbo:QboUser/qbo:CurrentCompany/qbo:BaseURI")[0]
              if element
                @base_uri = element.text
              else
                raise IntuitRequestException.new("Response error: Could not extract BaseURI from response. Invalid XML: #{service_response.body}")
              end
            else
              raise IntuitRequestException.new("Response error: invalid code #{response.code}")
            end
          end
        end

        def url_for_resource(resource)
          url_for_base("resource/#{resource}")
        end

        def url_for_base(raw)
          "#{@base_uri}/#{raw}/v2/#{@realm_id}"
        end

        def qb_base_uri_with_realm_id
          "#{QB_BASE_URI}/#{@realm_id}"
        end

        # store service base response
        # so it can be accessed by other methods
        def service_response
          @service_response ||= @oauth.request(:get, qb_base_uri_with_realm_id)
        end

        # allows for reuse of service base's xml doc
        # rather than loading it each time we need it
        def base_doc
          @base_doc ||= parse_xml(service_response.body)
        end
        
        # gives us the qbo user's LoginName
        # useful for verifying email address against
        def login_name
          @login_name ||= base_doc.xpath("//qbo:QboUser/qbo:LoginName")[0].text
        end

        private
        
        def determined_base_url?
          @base_uri != nil
        end

        def parse_xml(xml)
          Nokogiri::XML(xml)
        end

        def valid_xml_document(xml)
          %Q{<?xml version="1.0" encoding="utf-8"?>\n#{xml.strip}}
        end

        def fetch_collection(model, filters = [], page = 1, per_page = 20, sort = nil, options ={})
          raise ArgumentError, "missing model to instantiate" if model.nil?
          
          determine_base_url unless determined_base_url?

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
          response = do_http_post(url_for_resource(model.resource_for_collection), body, {}, {'Content-Type' => 'application/x-www-form-urlencoded'})
          if response
            collection = Quickeebooks::Collection.new
            xml = parse_xml(response.body)
            begin
              results = []
              collection.count = xml.xpath("//qbo:SearchResults/qbo:Count")[0].text.to_i
              if collection.count > 0
                xml.xpath("//qbo:SearchResults/qbo:CdmCollections/xmlns:#{model::XML_NODE}").each do |xa|
                  results << model.from_xml(xa)
                end
              end
              collection.entries = results
              collection.current_page = xml.xpath("//qbo:SearchResults/qbo:CurrentPage")[0].text.to_i
            rescue => ex
              #log("Error parsing XML: #{ex.message}")
              raise IntuitRequestException.new("Error parsing XML: #{ex.message}")
            end
            collection
          else
            nil
          end
        end

        def do_http_post(resource, body = "", params = {}, headers = {}) # throws IntuitRequestException
          url = add_query_string_to_url(resource, params)
          do_http(:post, resource, body, headers)
        end

        def do_http_get(resource, params = {}, headers = {}) # throws IntuitRequestException
          url = add_query_string_to_url(url, params)
          do_http(:get, resource, "", headers)
        end

        def do_http(method, resource, body, headers) # throws IntuitRequestException
          unless headers.has_key?('Content-Type')
            headers.merge!({'Content-Type' => 'application/xml'})
          end
          determine_base_url unless determined_base_url?
          # puts "METHOD = #{method}"
          # puts "URL = #{url}"
          # puts "BODY = #{body == nil ? "<NIL>" : body}"
          # puts "HEADERS = #{headers.inspect}"
          response = @oauth.request(method, resource, body, headers)
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
end
