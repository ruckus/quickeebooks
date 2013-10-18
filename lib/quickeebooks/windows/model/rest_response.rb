require "quickeebooks/windows/model/success"
require "quickeebooks/windows/model/error"

module Quickeebooks
  module Windows
    module Model
      class RestResponse < Quickeebooks::Windows::Model::IntuitType

        xml_convention :camelcase
        xml_accessor :success, :as => Quickeebooks::Windows::Model::Success
        xml_accessor :error, :as => Quickeebooks::Windows::Model::Error

        def success?
          success != nil
        end

        def error?
          error != nil
        end

        def to_s
          s = "#<RestResponse>: "
          if success?
            s += "Success[#{success.request_name}] @ #{success.processed_time} - "
          elsif error?
            s += "Error[#{error.request_name}] @ #{error.processed_time} - "
            s += "Code: #{error.code}, Desc: #{error.desc}"
          end
          s
        end

      end
    end
  end
end
