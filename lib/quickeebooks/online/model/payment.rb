require 'quickeebooks/online/model/payment_header'
require 'quickeebooks/online/model/payment_line_item'
require 'quickeebooks/online/model/payment_detail'
require 'quickeebooks/online/model/credit_card'
require 'quickeebooks/online/model/credit_charge_info'
require 'quickeebooks/online/model/credit_charge_response'
require 'quickeebooks/online/model/meta_data'

module Quickeebooks
  module Online
    module Model
      class Payment  < Quickeebooks::Online::Model::IntuitType
        XML_NODE = "Payment"
        REST_RESOURCE = "payment"

        include ActiveModel::Validations
        xml_convention :camelcase
        xml_accessor :id,         :from => 'Id',        :as => Quickeebooks::Online::Model::Id
        xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
        xml_accessor :meta_data,  :from => 'MetaData',  :as => Quickeebooks::Online::Model::MetaData
        xml_accessor :header,     :from => 'Header',    :as => Quickeebooks::Online::Model::PaymentHeader
        xml_accessor :line_items, :from => 'Line',      :as => [Quickeebooks::Online::Model::PaymentLineItem]

        def initialize
          ensure_line_items_initialization
        end

        def valid_for_update?
          errors.empty?
        end        

        def to_xml_ns(options = {})
          to_xml_inject_ns(XML_NODE, options)
        end

        def valid_for_deletion?
          return false if(id.nil? || sync_token.nil?)
          id.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
        end
        
        #== Class methods
        def self.resource_for_collection
          "#{self::REST_RESOURCE}s"
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