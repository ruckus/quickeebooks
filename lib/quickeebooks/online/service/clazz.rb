require 'quickeebooks/online/model/clazz'
require 'quickeebooks/online/service/service_base'

module Quickeebooks
  module Online
    module Service
      class Clazz < Quickeebooks::Online::Service::ServiceBase
        include ServiceCRUD
      end
    end
  end
end
