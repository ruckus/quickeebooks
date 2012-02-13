require "quickeebooks"

module Quickeebooks

  module Model
    class Phone < IntuitType
      xml_accessor :device_type, :from => 'DeviceType'
      xml_accessor :free_form_number, :from => 'FreeFormNumber'
    end
  end
end