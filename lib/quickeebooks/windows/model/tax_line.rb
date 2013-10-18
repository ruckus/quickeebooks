require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class TaxLine < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :desc, :from => 'Desc'
        xml_accessor :group_member, :from => 'GroupMember'
        xml_accessor :custom_fields, :from => 'CustomField', :as => [Quickeebooks::Windows::Model::CustomField]
        xml_accessor :amount, :from => 'Amount', :as => Float
        xml_accessor :tax_id, :from => 'TaxId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :tax_name, :from => 'TaxName'

      end
    end
  end
end
