require 'quickeebooks/online/service/service_base'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Job < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
