require 'quickeebooks/windows/model/ng_id'

module Quickeebooks
  module Windows
    module Model
      class NgIdSet < Quickeebooks::Windows::Model::IntuitType
        xml_convention :camelcase
        xml_accessor :ng_id, :from => 'NgId', :as => Quickeebooks::Windows::Model::NgId
        xml_accessor :sync_token, :from => 'SyncToken'
        xml_accessor :ng_object_type, :from => 'NgObjectType'
        xml_accessor :party_id, :from => 'PartyId'

        def initialize(value = nil)
          self.ng_id = Quickeebooks::Windows::Model::NgId.new(value)
        end

        def to_i
          self.ng_id ? self.ng_id.to_i : "__uninitialized__"
        end

        def to_s
          self.ng_id ? self.ng_id.to_s : "__uninitialized__"
        end

      end
    end
  end
end
