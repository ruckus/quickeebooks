require 'quickeebooks/online/model/clazz'
require 'quickeebooks/online/service/service_base'

module Quickeebooks
  module Online
    module Service
      class Clazz < Quickeebooks::Online::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Online::Model::Clazz, nil, filters, page, per_page, sort, options)
        end

      end
    end
  end
end