require "quickeebooks/windows/model/object_ref"
module Quickeebooks
  module Windows
    module Model
      class Error < Quickeebooks::Windows::Model::IntuitType
        
        xml_convention :camelcase
        
        xml_accessor :request_id, :from => '@RequestId'
        xml_accessor :object_ref, :as => Quickeebooks::Windows::Model::ObjectRef
        xml_accessor :request_name
        xml_accessor :processed_time, :as => Time
        xml_accessor :error_code
        xml_accessor :error_desc
        
      end
    end
  end
end