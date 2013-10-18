module Quickeebooks
  module Windows
    module Service
      class PaymentMethod < ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::PaymentMethod, nil, filters, page, per_page, sort, options)
        end


      end
    end
  end
end
