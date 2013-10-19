require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class Price < IntuitType
        xml_accessor :currency_code, :from => 'CurrencyCode'
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
