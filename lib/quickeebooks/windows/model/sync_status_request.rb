require 'quickeebooks/windows/model/id'
require 'quickeebooks/windows/model/id_set'
require 'quickeebooks/windows/model/sync_status_param'

module Quickeebooks
  module Windows
    module Model
      class SyncStatusRequest < Quickeebooks::Windows::Model::IntuitType

        DEFAULT_OFFERING_ID = 'ipp'

        # https://services.intuit.com/sb/status/v2/<realmID>
        REST_RESOURCE = "status"

        xml_convention :camelcase
        xml_accessor :offering_id
        xml_accessor :sync_status_param, :from => 'SyncStatusParam', :as => Quickeebooks::Windows::Model::SyncStatusParam
        xml_accessor :ng_id_set, :from => 'NgIdSet', :as => Quickeebooks::Windows::Model::NgIdSet

        def initialize(id = nil, type = nil, options = { :sync_status => true })
          self.offering_id = DEFAULT_OFFERING_ID

          if id && type
            if options[:sync_status]
              self.sync_status_param = Quickeebooks::Windows::Model::SyncStatusParam.new(id)
              self.sync_status_param.object_type = type
            else
              self.ng_id_set = Quickeebooks::Windows::Model::NgIdSet.new(id)
              self.ng_id_set.ng_object_type = type
            end
          end
        end
      end
    end
  end
end
