require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/employee'
require 'quickeebooks/common/service_crud'

module Quickeebooks
  module Online
    module Service
      class Employee < Quickeebooks::Online::Service::ServiceBase
        include ServiceCRUD
      end
    end
  end
end
