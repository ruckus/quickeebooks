require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/employee'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Employee < ServiceBase
        include ServiceCRUD
      end
    end
  end
end

