require "quickeebooks"

module Quickeebooks

  module Online
    module Model
      class Email < Quickeebooks::Online::Model::IntuitType
        xml_accessor :address, :from => 'Address'

        def to_xml(options = {})
          return "" if address.to_s.empty?
          super
        end

        def initialize(email_address = nil)
          unless email_address.nil?
            self.address = email_address
          end
        end

      end
    end
  end
end
