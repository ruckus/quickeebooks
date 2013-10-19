module Quickeebooks
  module Online
    module Model
      class JournalEntryLineItem < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations

        xml_name 'Line'
        xml_accessor :id,                         :from => 'Id',                      :as => Quickeebooks::Online::Model::Id
        xml_accessor :desc,                       :from => 'Desc'
        xml_accessor :amount,                     :from => 'Amount',                  :as => Float
        xml_accessor :class_id,                   :from => 'ClassId',       :as => Quickeebooks::Online::Model::Id
        xml_accessor :posting_type,               :from => 'PostingType'
        xml_accessor :account_id,                 :from => 'AccountId',     :as => Quickeebooks::Online::Model::Id
        xml_accessor :entity_id,                  :from => 'EntityId',      :as => Quickeebooks::Online::Model::Id
        xml_accessor :entity_type,                :from => 'EntityType'

        validates_inclusion_of :posting_type, :in => %w(Credit Debit)
        validates_presence_of  :amount, :account_id
      end
    end
  end
end
