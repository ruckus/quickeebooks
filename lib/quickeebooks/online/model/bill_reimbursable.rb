module Quickeebooks
  module Online
    module Model
      class ReimbursableInfo < Quickeebooks::Online::Model::IntuitType
        xml_name     'ReimbursableInfo'
        xml_accessor :customer_id,                :from => 'CustomerId',              :as => Quickeebooks::Online::Model::Id
        xml_accessor :customer_name,              :from => 'CustomerName'
      end
    end
  end
end
