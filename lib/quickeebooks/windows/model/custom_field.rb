require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class CustomField < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :definition_id, :from => 'DefinitionId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :value, :from => 'Value'
        xml_accessor :name, :from => 'Name'
      end
    end
  end
end
