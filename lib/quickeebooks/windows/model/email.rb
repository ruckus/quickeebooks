require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class Email < Quickeebooks::Online::Model::IntuitType
        include ActiveModel::Validations
        xml_accessor :address, :from => 'Address'
        xml_accessor :id, :from => 'Id'
        xml_accessor :default, :from => 'Default'
        xml_accessor :tag, :from => 'Tag'

        validates_length_of :address, :minimum => 1
        validate :ensure_valid_format

        def to_xml(options = {})
          return "" if address.to_s.empty?
          super
        end

        def initialize(email_address = nil)
          unless email_address.nil?
            self.address = email_address
          end
        end

        def default?
          default == "true"
        end

        private

        def ensure_valid_format
          # address must contain both @ and .
          if !address.include?('@') || !address.include?('.')
            errors.add(:address, "Address must contain both @ and .")
          end
        end

      end
    end
  end

end
