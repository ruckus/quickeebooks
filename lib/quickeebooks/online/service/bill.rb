require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/bill'
require 'quickeebooks/online/model/bill_header'
require 'quickeebooks/online/model/bill_line_item'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Bill < ServiceBase
        include ServiceCRUD
      end
    end
  end
end

