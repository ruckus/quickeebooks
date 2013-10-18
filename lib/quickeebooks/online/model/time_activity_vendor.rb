require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class TimeActivityVendor < Quickeebooks::Online::Model::IntuitType
        xml_accessor :vendor_id, :from => 'VendorId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :vendor_name, :from => 'VendorName'
      end
    end
  end
end
