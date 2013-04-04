require 'rexml/document'
require 'uri'
require 'cgi'
require 'quickeebooks/common/logging'

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
        include Logging
        attr_accessor :realm_id
        attr_accessor :oauth
        attr_accessor :base_uri

        QB_BASE_URI = "https://qbo.sbfinance.intuit.com"
        XML_NS = %{xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:ns3="http://www.intuit.com/sb/cdm"}

        def initialize(oauth_access_token = nil, realm_id = nil)
          if !oauth_access_token.nil? && !realm_id.nil?
            msg = "Quickeebooks::Online::ServiceBase - "
            msg += "This version of the constructor is deprecated. "
            msg += "Use the no-arg constructor and set the AccessToken (access_token=) and the RealmID (realm_id=) using the setters."
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

        def url_for_resource(resource)
          url_for_base("resource/#{resource}")
        end

        def url_for_base(raw)
          "#{QB_BASE_URI}/#{raw}/v2/#{@realm_id}"
        end

        # gives us the qbo user's LoginName
        # useful for verifying email address against
        def login_name
          @login_name ||= begin
            url = "https://qbo.intuit.com/qbo1/rest/user/v2/#{@realm_id}"
            response = @oauth.request(:get, url)
            if response && response.code.to_i == 200
              xml = parse_xml(response.body)
              xml.xpath("//qbo:QboUser/qbo:LoginName")[0].text
            end
          end
        end

        private
        
        def parse_xml(xml)
          Nokogiri::XML(xml)
        end

        def escape_filter(str)
          # Ampersand needs to double encoded within an Oath request.
          # CGI.escape will take the #26 and properly turn it into #2526
          str.gsub!('&','%26')
          CGI.escape(str)
        end

        def valid_xml_document(xml)
          %Q{<?xml version="1.0" encoding="utf-8"?>\n#{xml.strip}}
        end

        def fetch_collection(model, filters = [], page = 1, per_page = 20, sort = nil, options ={})
          raise ArgumentError, "missing model to instantiate" if model.nil?
          
          post_body_lines = []

          if filters.is_a?(Array) && filters.length > 0
            filter_string = filters.collect { |f| f.to_s }
            post_body_lines << "Filter=#{escape_filter(filter_string.join(" :AND: "))}"
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
              raise IntuitRequestException.new("Error parsing XML: #{ex.message}")
            end
            collection
          else
            nil
          end
        end

        def do_http_post(resource, body = "", params = {}, headers = {}) # throws IntuitRequestException
          url = add_query_string_to_url(resource, params)
          do_http(:post, url, body, headers)
        end

        def do_http_get(resource, params = {}, headers = {}) # throws IntuitRequestException
          url = add_query_string_to_url(resource, params)
          do_http(:get, url, "", headers)
        end

        def do_http(method, resource, body, headers) # throws IntuitRequestException
          unless headers.has_key?('Content-Type')
            headers.merge!({'Content-Type' => 'application/xml'})
          end
          log "------ New Request ------"
          log "METHOD = #{method}"
          log "RESOURCE = #{resource}"
          log "BODY(#{body.class}) = #{body == nil ? "<NIL>" : body.inspect}"
          log "HEADERS = #{headers.inspect}"

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
          log "RESPONSE CODE = #{response.code}"
          log "RESPONSE BODY = #{response.body}"
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

      end
    end
  end
end
