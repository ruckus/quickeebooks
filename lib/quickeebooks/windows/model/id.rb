require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class Id < Quickeebooks::Windows::Model::IntuitType

        DOMAIN = "QB"

        xml_convention :camelcase
        xml_accessor :idDomain, :from => '@idDomain' # Attribute with name 'idDomain'
        xml_accessor :value, :from => :content

        def initialize(value = nil, suppress_domain_attribute = false)
          unless suppress_domain_attribute
            self.idDomain = DOMAIN
          end
          self.value = value
        end

        def to_i
          self.value.to_i
        end

        def to_s
          self.value.to_s
        end

      end
    end
  end
end
