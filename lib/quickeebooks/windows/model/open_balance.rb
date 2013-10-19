require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class OpenBalance < IntuitType
        xml_accessor :amount, :from => 'Amount', :as => Float
      end
    end
  end
end
