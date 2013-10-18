module Quickeebooks
  module Windows
    module Model
      class IdSet < Quickeebooks::Windows::Model::IntuitType

        xml_convention :camelcase
        xml_accessor :id, :from => 'Id', :as => Quickeebooks::Windows::Model::Id

        def initialize(value = nil)
          self.id = Quickeebooks::Windows::Model::Id.new(value, true)
        end

        def to_i
          id ? id.to_i : "__uninitialized__"
        end

        def to_s
          id ? id.to_s : "__uninitialized__"
        end

      end
    end
  end
end
