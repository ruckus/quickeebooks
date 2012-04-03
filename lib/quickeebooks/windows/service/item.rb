require 'quickeebooks/windows/model/item'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Item < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          custom_field_query = '<ItemQuery xmlns="http://www.intuit.com/sb/cdm/v2"><CustomFieldEnable>true</CustomFieldEnable></ItemQuery>'
          fetch_collection("item", "Item", Quickeebooks::Windows::Model::Item, custom_field_query, filters, page, per_page, sort, options)
        end

      end
    end
    
  end
end