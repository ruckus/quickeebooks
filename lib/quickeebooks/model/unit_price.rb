require "quickeebooks"

module Quickeebooks

  module Model
    class UnitPrice < IntuitType
      xml_accessor :amount, :from => 'Amount', :as => Float
    end
  end
end