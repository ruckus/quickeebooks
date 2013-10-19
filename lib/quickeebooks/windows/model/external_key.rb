require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class ExternalKey < Quickeebooks::Windows::Model::IntuitType

        DOMAIN = "QB"

        xml_convention :camelcase
        xml_accessor :idDomain, :from => '@idDomain' # Attribute with name 'idDomain'
        xml_accessor :value, :from => :content

        def initialize(value = nil)
          self.idDomain = DOMAIN
          self.value = value
        end
      end
    end
  end
end
