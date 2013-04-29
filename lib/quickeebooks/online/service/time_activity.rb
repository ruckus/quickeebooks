require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/time_activity'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class TimeActivity < ServiceBase
        include ServiceCRUD
      end
    end
  end
end

