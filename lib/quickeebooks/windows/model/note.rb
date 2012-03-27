require 'quickeebooks'

module Quickeebooks
  module Windows
    module Model
      class Note < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :id, :from => 'Id'
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :synchronized, :from => 'Synchronized'
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :external_key, :from => 'ExternalKey'
        xml_accessor :draft
        xml_accessor :content, :from => 'Content'
        xml_accessor :object_state, :from => 'ObjectState'
      end
    end
  end
end
