require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/sync_status_request'

module Quickeebooks
  module Windows
    module Service
      class SyncStatus < Quickeebooks::Windows::Service::ServiceBase

        def retrieve(sync_status_request, errored_objects_only = false)
          unless sync_status_request.is_a?(Quickeebooks::Windows::Model::SyncStatusRequest)
            raise ArgumentError.new("Expecting an +SyncStatusRequest+ instance as an argument")
          end

          xml_node = sync_status_request.to_xml

          if errored_objects_only
            xml_node.set_attribute('ErroredObjectsOnly', 'true')
          end

          xml_node.set_attribute('xmlns', 'http://www.intuit.com/sb/cdm/v2')
          xml_node.set_attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance')
          xml_node.set_attribute('xsi:schemaLocation', 'http://www.intuit.com/sb/cdm/v2 RestDataFilter.xsd ')

          xml = xml_node.to_s

          model = Quickeebooks::Windows::Model::SyncStatusResponse
          response = do_http_post(url_for_resource(model::REST_RESOURCE), xml, {}, {'Content-Type' => 'text/xml'})
          parse_collection(response, model)
        end

      end
    end
  end
end
