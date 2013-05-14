require "quickeebooks"

# See https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0025_Intuit_Anywhere/0020_Connect/0010_From_Within_Your_App/Implement_OAuth_in_Your_App/Token_Renewal_and_Expiration
module Quickeebooks
  module Shared
    module Service
      class AccessTokenResponse
        include ROXML

        xml_convention :camelcase
        xml_accessor :error_code
        xml_accessor :error_message
        xml_accessor :token,  :from => 'OAuthToken'
        xml_accessor :secret, :from => 'OAuthTokenSecret'

        def error?
          error_code.to_i != 0
        end
      end
      module AccessToken
        # see https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0025_Intuit_Anywhere/0060_Reference/3002_Reconnect_API
        def reconnect
          response = do_http_get("https://appcenter.intuit.com/api/v1/Connection/Reconnect")
          if response && response.code.to_i == 200
            Quickeebooks::Shared::Service::AccessTokenResponse.from_xml(response.body)
          else
            nil
          end
        end

        # see https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0025_Intuit_Anywhere/0060_Reference/3001_Disconnect_API
        def disconnect
          response = do_http_get("https://appcenter.intuit.com/api/v1/Connection/Disconnect")
          if response && response.code.to_i == 200
            Quickeebooks::Shared::Service::AccessTokenResponse.from_xml(response.body)
          else
            nil
          end
        end
      end
    end
  end
end
