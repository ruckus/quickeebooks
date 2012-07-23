require 'quickeebooks/online/service/service_base'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      # read only, corresponds to the realm_id
      # see https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0050_Data_Services/0400_QuickBooks_Online/CompanyMetaData
      class CompanyMetaData < ServiceBase

        def load
          url = url_for_resource(Quickeebooks::Online::Model::CompanyMetaData.resource_for_singular)
          response = do_http_get(url)
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::CompanyMetaData.from_xml(response.body)
          else
            nil
          end

        end
      end
    end
  end
end
