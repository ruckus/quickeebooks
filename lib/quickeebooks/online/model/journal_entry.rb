require "quickeebooks"
require 'quickeebooks/online/model/journal_entry_header'
require 'quickeebooks/online/model/journal_entry_line_item'
require "quickeebooks/online/model/meta_data"
require "quickeebooks/online/model/id"

module Quickeebooks
  module Online
    module Model
      class JournalEntry < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        include OnlineLineItemModelMethods

        XML_NODE = "JournalEntry"
        REST_RESOURCE = "journal-entry"

        xml_name "JournalEntry"
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :doc_number, :from => 'DocNumber', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header,     :from => 'Header',    :as => Quickeebooks::Online::Model::JournalEntryHeader
        xml_accessor :line_items, :from => 'Line',      :as => [Quickeebooks::Online::Model::JournalEntryLineItem]

        def self.resource_for_collection
          'journal-entries'
        end

      end
    end
  end
end
