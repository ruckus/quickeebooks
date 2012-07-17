require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class Id < Quickeebooks::Online::Model::IntuitType
        
        
        DOMAIN = "QBO"
        
        xml_convention :camelcase
        xml_accessor :idDomain, :from => '@idDomain' # Attribute with name 'idDomain'
        xml_accessor :value, :from => :content
        
        def initialize(value = nil)
          self.value = value
        end
      end
    end
  end
end