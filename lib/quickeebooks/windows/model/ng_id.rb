module Quickeebooks
  module Windows
    module Model
      class NgId < Quickeebooks::Windows::Model::IntuitType

        xml_convention :camelcase
        xml_accessor :value, :from => :content

        def initialize(value = nil)
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
