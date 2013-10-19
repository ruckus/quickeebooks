require "quickeebooks/windows/model/object_ref"
require "quickeebooks/windows/model/party_role_ref"

module Quickeebooks
  module Windows
    module Model
      class Success < Quickeebooks::Windows::Model::IntuitType

        xml_convention :camelcase

        xml_accessor :request_id, :from => '@RequestId'
        xml_accessor :object_ref, :as => Quickeebooks::Windows::Model::ObjectRef
        xml_accessor :party_role_ref, :as => Quickeebooks::Windows::Model::PartyRoleRef
        xml_accessor :request_name
        xml_accessor :processed_time, :as => Time

      end
    end
  end
end
