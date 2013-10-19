require "quickeebooks"
require 'quickeebooks/windows/model/other_name_id'

module Quickeebooks
  module Windows
    module Model
      class OtherName < Quickeebooks::Windows::Model::IntuitType

        xml_convention :camelcase
        xml_accessor :other_name_id, :from => 'OtherNameId', :as => Quickeebooks::Windows::Model::OtherNameId
        xml_accessor :other_name_name

      end
    end
  end
end
