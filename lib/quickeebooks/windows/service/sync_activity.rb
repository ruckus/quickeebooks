require 'quickeebooks/windows/service/service_base'
require 'active_support/builder' unless defined?(Builder)

module Quickeebooks
  module Windows
    module Service
      class SyncActivity < Quickeebooks::Windows::Service::ServiceBase

        # Fetch +SyncActivity+ objects
        # Arguments:
        # parameters: +Hash+ of attributes accepted to select +SyncActivityResponse+ objects
        def retrieve(parameters={})
          model = Quickeebooks::Windows::Model::SyncActivityResponse

          response = do_http_post(url_for_resource(model::REST_RESOURCE), xml_body(parameters), {}, {'Content-Type' => 'text/xml'})
          parse_collection(response, model)
        end

      private

        def xml_body(parameters)
          parameters.reverse_merge!(:offering_id => "ipp")

          xml = Builder::XmlMarkup.new
          xml.instruct!
          xml.tag!('SyncActivityRequest', "xmlns" => "http://www.intuit.com/sb/cdm/v2", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.intuit.com/sb/cdm/v2 RestDataFilter.xsd ") do |request|
            parameters.each {|key, value| ActiveSupport::XmlMini.to_tag(key, value, {:camelize => true, :skip_type => true, :builder => request})}
          end
          xml.target!
        end

      end
    end
  end
end
