require 'quickeebooks/shared/service/access_token'

module Quickeebooks
  module Windows
    module Service
      class AccessToken < ServiceBase
        include Quickeebooks::Shared::Service::AccessToken
      end
    end
  end
end
