require 'quickeebooks/common/date_time'

module Quickeebooks
  module Online
    module Model
      class JournalEntryHeader < Quickeebooks::Online::Model::IntuitType
        xml_name 'Header'
        xml_accessor :doc_number,            :from => 'DocNumber'
        xml_accessor :txn_date,              :from => 'TxnDate',            :as => Quickeebooks::Common::DateTime
        xml_accessor :msg,                   :from => 'Msg'
        xml_accessor :note,                  :from => 'Note'
      end
    end
  end
end
