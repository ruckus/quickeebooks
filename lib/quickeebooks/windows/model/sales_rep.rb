require 'quickeebooks'
require 'quickeebooks/windows/model/id'
require 'quickeebooks/windows/model/vendor'
require 'quickeebooks/windows/model/other_name'
require 'quickeebooks/windows/model/external_key'
require 'quickeebooks/windows/model/meta_data'

module Quickeebooks
  module Windows
    module Model
      class SalesRep < Quickeebooks::Windows::Model::IntuitType

        XML_COLLECTION_NODE = 'SalesReps'
        XML_NODE = 'SalesRep'

        # https://services.intuit.com/sb/salesrep/v2/<realmID>
        REST_RESOURCE = "salesrep"

        xml_convention :camelcase
        xml_accessor :id, :as => Quickeebooks::Windows::Model::Id
        xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :external_key, :as => Quickeebooks::Windows::Model::ExternalKey
        xml_accessor :synchronized
        xml_accessor :name_of, :from => 'NameOf'
        xml_accessor :vendor, :as => Quickeebooks::Windows::Model::Vendor
        xml_accessor :other_name, :as => Quickeebooks::Windows::Model::OtherName
        xml_accessor :initials

        def vendor?
          vendor != nil
        end

        def other_name?
          other_name != nil
        end

      end
    end
  end
end
