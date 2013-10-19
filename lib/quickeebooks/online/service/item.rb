require 'quickeebooks/online/model/item'
require 'quickeebooks/online/service/service_base'

module Quickeebooks
  module Online
    module Service
      class Item < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
