require 'quickeebooks'

module Quickeebooks
  module Windows
    module Model
      class SyncStatusDrillDown < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :sync_event_id, :from => 'SyncEventId'
        xml_accessor :sync_tms, :from => 'SyncTMS', :as => Time
        xml_accessor :entity_id, :from => 'EntityId'
        xml_accessor :request_id, :from => 'RequestId'
        xml_accessor :ng_object_type, :from => 'NgObjectType'
        xml_accessor :operation_type, :from => 'OperationType'
        xml_accessor :sync_message_code, :from => 'SyncMessageCode'
        xml_accessor :sync_message, :from => 'SyncMessage'
      end
    end
  end
end
