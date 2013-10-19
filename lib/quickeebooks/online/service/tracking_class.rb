require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/tracking_class'
require 'quickeebooks/common/service_crud'

module Quickeebooks
  module Online
    module Service
      class TrackingClass < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
