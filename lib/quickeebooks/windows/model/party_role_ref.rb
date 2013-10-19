module Quickeebooks
  module Windows
    module Model
      class PartyRoleRef < Quickeebooks::Windows::Model::IntuitType
        xml_convention :camelcase
        xml_accessor :id, :as => Quickeebooks::Windows::Model::Id
        xml_accessor :party_reference_id, :as => Quickeebooks::Windows::Model::Id
        xml_accessor :last_updated_time, :as => Time
      end
    end
  end
end
