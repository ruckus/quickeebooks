require 'quickeebooks'

module Quickeebooks
  module Windows
    module Model
      class Status < Quickeebooks::Windows::Model::IntuitType

        XML_COLLECTION_NODE = 'SyncStatusResponses'
        XML_NODE = 'SyncStatusResponse'
        
        # https://services.intuit.com/sb/shipmethod/v2/<realmID>
        REST_RESOURCE = "status"
        
        xml_convention :camelcase
        xml_accessor :StateCode
        xml_accessor :StateDesc
        xml_accessor :MessageCode
        xml_accessor :MessageDesc
        xml_accessor :NgIdSet, :as => Quickeebooks::Windows::Model::NgIdSet

      end
    end
  end
end