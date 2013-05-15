require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class SyncActivity < Quickeebooks::Windows::Service::ServiceBase

        def retrieve
          model = Quickeebooks::Windows::Model::SyncActivityResponse
          body = %Q{<?xml version="1.0"?><SyncActivityRequest xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.intuit.com/sb/cdm/v2 RestDataFilter.xsd "><OfferingId>ipp</OfferingId></SyncActivityRequest>}

          response = do_http_post(url_for_resource(model::REST_RESOURCE), body, {}, {'Content-Type' => 'text/xml'})
          parse_collection(response, model)
        end

      end
    end
  end
end
