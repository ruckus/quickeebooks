require 'quickeebooks/shared/service/access_token'

module Quickeebooks
  module Online
    module Service
      class AccessToken < ServiceBase
        include Quickeebooks::Shared::Service::AccessToken
      end
    end
  end
end
