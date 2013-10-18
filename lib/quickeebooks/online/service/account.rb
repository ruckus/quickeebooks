require 'quickeebooks/online/model/account'
require 'quickeebooks/online/service/service_base'

module Quickeebooks
  module Online
    module Service
      class Account < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
