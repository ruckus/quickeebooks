require 'rexml/document'
require 'uri'
require 'cgi'
require 'uuidtools'

class IntuitRequestException < Exception
  attr_accessor :code, :cause
  def initialize(msg)
    super(msg)
  end
end
class AuthorizationFailure < Exception; end

module Quickeebooks
  module Windows
    module Service
      class ServiceBase

        attr_accessor :realm_id
        attr_accessor :oauth
        attr_reader :base_uri
        attr_reader :last_response_body
        attr_reader :last_response_xml

        XML_NS = %{xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:ns3="http://www.intuit.com/sb/cdm"}

        def initialize(oauth_access_token, realm_id)
          @base_uri = 'https://services.intuit.com/sb'
          @oauth = oauth_access_token
          @realm_id = realm_id
        end

        def url_for_resource(resource)
          url_for_base(resource)
        end

        def url_for_base(raw)
          "#{@base_uri}/#{raw}/v2/#{@realm_id}"
        end
        
        def guid
          UUIDTools::UUID.random_create.to_s.gsub('-', '')
        end

        private

        def parse_xml(xml)
          @last_response_xml ||= 
          begin
            x = Nokogiri::XML(xml)
            #x.document.remove_namespaces!
            x
          end
        end

        def valid_xml_document(xml)
          %Q{<?xml version="1.0" encoding="utf-8"?>\n#{xml.strip}}
        end

        def fetch_collection(resource, container, model, custom_field_query = nil, filters = [], page = 1, per_page = 20, sort = nil, options ={})
          raise ArgumentError, "missing resource to fetch" if resource.nil?
          raise ArgumentError, "missing result container" if container.nil?
          raise ArgumentError, "missing model to instantiate" if model.nil?

          if custom_field_query != nil
            response = do_http_post(url_for_resource(resource), custom_field_query, {}, {'Content-Type' => 'text/xml'})
          else
            response = do_http_get(url_for_resource(resource), {}, {'Content-Type' => 'text/html'})
          end
          if response
            collection = Quickeebooks::Collection.new
            xml = parse_xml(response.body)
            begin
              results = []
              path_to_nodes = "//xmlns:RestResponse/xmlns:#{model::XML_COLLECTION_NODE}/xmlns:#{model::XML_NODE}"
              collection.count = xml.xpath(path_to_nodes).count
              if collection.count > 0
                xml.xpath(path_to_nodes).each do |xa|
                  entry = model.from_xml(xa)
                  results << entry
                end
              end
              collection.entries = results
              collection.current_page = 1 # TODO: fix this
            rescue => ex
              log("Error parsing XML: #{ex.message}")
              raise IntuitRequestException.new("Error parsing XML: #{ex.message}")
            end
            collection
          else
            nil
          end
        end
        
        def perform_write(resource, body = "", params = {}, headers = {})
          url = url_for_resource(resource)
          unless headers.has_key?('Content-Type')
            headers['Content-Type'] = 'text/xml'
          end
          response = do_http_post(url, body.strip, params, headers)
          
          result = nil
          if response
            case response.code.to_i
            when 200
              result = Quickeebooks::Windows::Model::RestResponse.from_xml(response.body)
            when 401
              raise IntuitRequestException.new("Authorization failure: token timed out?")
            when 404
              raise IntuitRequestException.new("Resource Not Found: Check URL and try again")
            end
          end
          result
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
          parse_xml(response.body)
          status = response.code.to_i
          case status
          when 200
            # even HTTP 200 can contain an error, so we always have to peek for an Error
            if response_is_error?
              parse_and_raise_exceptione
            else
              response
            end
          when 302
            raise "Unhandled HTTP Redirect"
          when 401
            raise AuthorizationFailure
          when 400, 500
            parse_and_raise_exceptione
          else
            raise "HTTP Error Code: #{status}, Msg: #{response.body}"
          end
        end
        
        def parse_and_raise_exceptione
          err = parse_intuit_error
          ex = IntuitRequestException.new(err[:message])
          ex.code = err[:code]
          ex.cause = err[:cause]
          raise ex
        end
        
        def response_is_error?
          @last_response_xml.xpath("//xmlns:RestResponse/xmlns:Error").first != nil
        end

        def parse_intuit_error
          error = {:message => "", :code => 0, :cause => ""}
          fault = @last_response_xml.xpath("//xmlns:RestResponse/xmlns:Error/xmlns:ErrorDesc")[0]
          if fault
            error[:message] = fault.text
          end
          error_code = @last_response_xml.xpath("//xmlns:RestResponse/xmlns:Error/xmlns:ErrorCode")[0]
          if error_code
            error[:code] = error_code.text
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