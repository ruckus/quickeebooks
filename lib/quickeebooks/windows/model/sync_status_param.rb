require 'quickeebooks/windows/model/id_set'

module Quickeebooks
  module Windows
    module Model
      class SyncStatusParam < Quickeebooks::Windows::Model::IntuitType
        xml_convention :camelcase
        xml_accessor :id_set, :from => 'IdSet', :as => Quickeebooks::Windows::Model::IdSet
        xml_accessor :sync_token, :from => 'SyncToken'
        xml_accessor :object_type, :from => 'ObjectType'
        xml_accessor :party_id, :from => 'PartyId'

        def initialize(value = nil)
          self.id_set = Quickeebooks::Windows::Model::IdSet.new(value)
        end

        def to_i
          self.id_set ? self.id_set.to_i : "__uninitialized__"
        end

        def to_s
          self.id_set ? self.id_set.to_s : "__uninitialized__"
        end

      end
    end
  end
end
