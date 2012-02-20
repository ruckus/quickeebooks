module Quickeebooks
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