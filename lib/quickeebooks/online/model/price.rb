require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class Price < Quickeebooks::Online::Model::IntuitType
        xml_accessor :amount, :from => 'Amount', :as => Float

        def initialize(amount = nil)
          if amount
            self.amount = amount
          end
        end

      end
    end
  end
end
