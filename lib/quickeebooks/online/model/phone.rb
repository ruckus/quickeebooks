require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class Phone < Quickeebooks::Online::Model::IntuitType
        xml_accessor :device_type, :from => 'DeviceType'
        xml_accessor :free_form_number, :from => 'FreeFormNumber'
      end
    end
  end
end
