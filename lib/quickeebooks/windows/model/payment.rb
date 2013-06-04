require 'quickeebooks/windows/model/payment_header'
require 'quickeebooks/windows/model/payment_line_item'
require 'quickeebooks/windows/model/payment_detail'
require 'quickeebooks/windows/model/credit_card'
require 'quickeebooks/windows/model/credit_charge_info'
require 'quickeebooks/windows/model/credit_charge_response'
require 'quickeebooks/windows/model/meta_data'

module Quickeebooks
  module Windows
    module Model
      class Payment  < Quickeebooks::Windows::Model::IntuitType
        include ActiveModel::Validations

        XML_COLLECTION_NODE = 'Payments'
        XML_NODE = "Payment"
        REST_RESOURCE = "payment"

        xml_convention :camelcase
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Windows::Model::MetaData
        xml_accessor :header,     :from => 'Header',    :as => Quickeebooks::Windows::Model::PaymentHeader
        xml_accessor :line_items, :from => 'Line',      :as => [Quickeebooks::Windows::Model::PaymentLineItem]

        def initialize
          ensure_line_items_initialization
        end

        def valid_for_create?
          valid?
          if header.nil?
            errors.add(:header, "Missing Header field for Create")
          # else
          #   # ensure header is valid
          #   unless header.valid?
          #     #errors.concat(header.errors)
          #     #errors[:base].each {|e| header.errors[:base] << e }
          #   end
          end
          errors.empty?
        end

        private

        def after_parse
        end

        def ensure_line_items_initialization
          self.line_items ||= []
        end
      end
    end
  end
end
