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
  module Windows
    module Service
      class ServiceBase

        attr_accessor :realm_id
        attr_accessor :oauth
        attr_reader :base_uri
        attr_reader :last_response_xml

        XML_NS = %{xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:ns3="http://www.intuit.com/sb/cdm"}

        def initialize(oauth_access_token, realm_id)
          @base_uri = 'https://services.intuit.com/sb'
          @oauth = oauth_access_token
          @realm_id = realm_id
        end

        def url_for_resource(resource)
          url_for_base("resource/#{resource}")
        end

        def url_for_base(raw)
          "#{@base_uri}/#{raw}/v2/#{@realm_id}"
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

        def fetch_collection(resource, container, model, filters = [], page = 1, per_page = 20, sort = nil, options ={})
          raise ArgumentError, "missing resource to fetch" if resource.nil?
          raise ArgumentError, "missing result container" if container.nil?
          raise ArgumentError, "missing model to instantiate" if model.nil?

          response = do_http_get(url_for_resource(resource), {}, {'Content-Type' => 'text/html'})
          if response
            collection = QuickeebooksQbw::Collection.new
            xml = parse_xml(response.body)
            begin
              results = []
              path_to_nodes = "//xmlns:RestResponse/xmlns:#{model::XML_COLLECTION_NODE}/xmlns:#{model::XML_NODE}"
              puts path_to_nodes
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
          QuickeebooksQbw.logger.info(msg)
          QuickeebooksQbw.logger.flush if Quickeebooks.logger.respond_to?(:flush)
        end

      end
    end
  end
end