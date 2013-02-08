require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class NgIdSet < Quickeebooks::Windows::Model::IntuitType
        
        xml_convention :camelcase
        xml_accessor :NgId
        xml_accessor :NgObjectType
                
      end
    end
  end
end