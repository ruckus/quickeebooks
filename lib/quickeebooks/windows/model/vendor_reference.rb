require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class VendorReference < IntuitType
        xml_accessor :vendor_id, :from => 'VendorId'
        xml_accessor :vendor_name, :from => 'VendorName'

      end
    end
  end
end
