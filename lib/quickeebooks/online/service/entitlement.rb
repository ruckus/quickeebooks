module Quickeebooks
  module Online
    module Service
      class Entitlement < ServiceBase

        def status
          url = url_for_base("manage/entitlements")
          response = do_http_get(url)
          puts response.body
        end

      end
    end
  end
end
