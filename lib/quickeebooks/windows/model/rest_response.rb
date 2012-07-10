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
        
      end
    end
  end
end