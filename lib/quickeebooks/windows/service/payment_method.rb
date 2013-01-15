require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/payment_method'

require 'nokogiri'

module Quickeebooks
  module Windows
    module Service
      class PaymentMethod < ServiceBase
        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::PaymentMethod::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::PaymentMethod, url, { :idDomain => idDomain })
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::PaymentMethod, nil, filters, page, per_page, sort, options)
        end
      end
    end
  end
end
