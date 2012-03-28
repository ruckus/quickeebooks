require 'quickeebooks/windows/model/item'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Item < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection("item", "Item", Quickeebooks::Windows::Model::Item, filters, page, per_page, sort, options)
        end

      end
    end
    
  end
end