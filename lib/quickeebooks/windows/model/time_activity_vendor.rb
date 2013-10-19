require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class TimeActivityVendor < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :vendor_id, :from => 'VendorId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :vendor_name, :from => 'VendorName'
      end
    end
  end
end
