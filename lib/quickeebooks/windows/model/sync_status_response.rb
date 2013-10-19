module Quickeebooks
  module Windows
    module Model
      class SyncStatusResponse < Quickeebooks::Windows::Model::IntuitType

        XML_COLLECTION_NODE = 'SyncStatusResponses'
        XML_NODE = 'SyncStatusResponse'
        # https://services.intuit.com/sb/status/v2/<realmID>
        REST_RESOURCE = "status"

        STATE_CODES = {
          1 => {
            :desc => 'Synchronized',
            :verbose => 'Synchronized (successful). Object created in QuickBooks. Equivalent to StateCode 8 (for object created in Data Services).'
          },
          2 => {
            :desc => 'Source record created',
            :verbose => 'Not synchronized. Object created in Quickbooks.'
          },
          3 => {
            :desc => 'Source record modified',
            :verbose => 'Not synchronized. Object modified in Quickbooks.'
          },
          4 => {
            :desc => 'Next Gen record created',
            :verbose => 'Not synchronized. Object created in Data Services. The same object subsequently modified on the cloud, without being sync\'d, will retain a StateCode 4 until it has been sync\'d with QuickBooks and then modified.'
          },
          5 => {
            :desc => 'Next Gen record modified',
            :verbose => 'Not synchronized. Object modified in Data Services that has been sync\'d at least once with QuickBooks.'
          },
          6 => {
            :desc => 'Next Gen to Source, no ack',
            :verbose => 'Not synchronzied. The synchronization is currently in progress; Sync Manager has not completed processing or acknowledged completion.'
          },
          7 => {
            :desc => 'Record has conflict',
            :verbose => 'Not synchronized. To resolve this conflict, change the object in Data Services.'
          },
          8 => {
            :desc => 'Record netted',
            :verbose => 'Synchronized. Object created in Data Services. Sync Manager has acknowledged synchronizing the object and mapped its NG ID to a QB ID in QuickBooks. Equivalent to StateCode 1 (for object created in QuickBooks).'
          },
          9 => {
            :desc => 'Record has conflict, unrecoverable',
            :verbose => 'Not synchronized. The synchronization was rejected by Quickbooks because of a bad record or unsupported operation.'
          }
        }

        MESSAGE_CODES = {
          10 => {
            :desc => 'ADD success',
            :verbose => 'Object to be added was successfully written to Data Services, awaiting synch with QuickBooks.'
          },
          20 => {
            :desc => 'MOD success',
            :verbose => 'Object to be modified was successfully modified in Data Services, awaiting synch with QuickBooks.'
          },
          30 => {
            :desc => 'QBXML sent to desktop',
            :verbose => 'Requests have been sent down from Data Services to the QuickBooks desktop company file for an attempted synch.'
          },
          40 => {
            :desc => 'WRTB success',
            :verbose => 'The requests sent from Data Services to the QuickBooks company file were successfully synched into the company file.'
          },
          50 => {
            :desc => 'WRTB error',
            :verbose => 'The requests sent from Data Services to the QuickBooks company file failed to synch and are not in the company file.'
          },
          60 => {
            :desc => 'ADD MOD error',
            :verbose => 'The Add or Mod of an object in Data Services failed. The object was not added to Data Services or modified in Data Services.'
          },
          80 => {
            :desc => 'Auto_Revert',
            :verbose => 'This error is returned whenever an object, which fails to synchronize due to write back errors, is reverted to a state prior to the error.'
          },
          90 => {
            :desc => 'DEL success',
            :verbose => nil
          },
          100 => {
            :desc => 'Generic QB SDK communication failure',
            :verbose => nil
          },
          110 => {
            :desc => 'Upload ADD success',
            :verbose => nil
          },
          120 => {
            :desc => 'Upload MOD success',
            :verbose => nil
          },
          130 => {
            :desc => 'Upload error',
            :verbose => nil
          },
          200 => {
            :desc => 'Missing ExtAcctId with state = 1, forcing to state = 7',
            :verbose => 'Objects now have StateCode 7.'
          },
          210 => {
            :desc => 'Orphaned state = 8, forcing to state = 7',
            :verbose => 'Objects are orphaned when they existed on the cloud, synchronization with QuickBooks did not complete, but then the user restored an older company file from backup on the desktop, then sync\'d; the objects on the cloud have lost their corresponding QuickBooks identity and cannot be resolved, so they have been forced back to StateCode 7.'
          },
          220 => {
            :desc => 'Stuck while in state = 6, forcing to state = 7',
            :verbose => 'Objects now have StateCode 7.'
          },
          230 => {
            :desc => 'Stuck while in state = 6, forcing to prior state',
            :verbose => 'Objects have been rolled back to previous state. No synchronization occurred.'
          },
          240 => {
            :desc => 'Internal WRTB to ESB API ack error - Sync Manager failed validation',
            :verbose => 'Objects now have StateCode 7.'
          },
          250 => {
            :desc => 'State Rollback all prior objects',
            :verbose => 'Objects have been rolled back to previous state. No synchronization occurred.'
          }
        }

        xml_convention :camelcase
        xml_accessor :offering_id, :as => Quickeebooks::Windows::Model::Id
        xml_accessor :ng_id_set, :as => Quickeebooks::Windows::Model::NgIdSet
        xml_accessor :request_id, :from => 'RequestId'
        xml_accessor :batch_id, :from => 'BatchId'

        xml_accessor :state_code, :from => 'StateCode'
        xml_accessor :state_desc, :from => 'StateDesc'
        xml_accessor :message_code, :from => 'MessageCode'
        xml_accessor :message_desc, :from => 'MessageDesc'
        xml_accessor :response_log_tms, :from => 'ResponseLogTMS', :as => Time

        def verbose_state_description
          if STATE_CODES[state_code.to_i]
            STATE_CODES[state_code.to_i][:verbose]
          else
            nil
          end
        end

        def verbose_message_description
          if MESSAGE_CODES[message_code.to_i]
            MESSAGE_CODES[message_code.to_i][:verbose]
          else
            nil
          end
        end

      end
    end
  end
end
