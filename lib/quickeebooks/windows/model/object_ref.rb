module Quickeebooks
  module Windows
    module Model
      class ObjectRef < Quickeebooks::Windows::Model::IntuitType

        xml_convention :camelcase
        xml_accessor :id, :as => Quickeebooks::Windows::Model::Id
        xml_accessor :sync_token, :as => Integer
        xml_accessor :last_updated_time, :as => Time

      end
    end
  end
end
