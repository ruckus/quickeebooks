require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class PurchaseCost < Quickeebooks::Online::Model::IntuitType
        xml_accessor :amount, :from => 'Amount', :as => Float
      end
    end
  end
end
