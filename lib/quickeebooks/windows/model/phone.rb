require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class Phone < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :id, :from => 'Id'
        xml_accessor :device_type, :from => 'DeviceType'
        xml_accessor :free_form_number, :from => 'FreeFormNumber'
        xml_accessor :default, :from => 'Default'
        xml_accessor :tag, :from => 'Tag'

        def default?
          default == "true"
        end

      end
    end
  end
end
