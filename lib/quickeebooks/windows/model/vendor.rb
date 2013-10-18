require "quickeebooks"
require 'quickeebooks/windows/model/vendor_id'

module Quickeebooks
  module Windows
    module Model
      class Vendor < Quickeebooks::Windows::Model::IntuitType
        include Quickeebooks::Model::Addressable

        xml_convention :camelcase
        xml_accessor :vendor_id, :from => 'VendorId', :as => Quickeebooks::Windows::Model::VendorId
        xml_accessor :vendor_name

      end
    end
  end
end
