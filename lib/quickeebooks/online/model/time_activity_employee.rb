require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class TimeActivityEmployee < Quickeebooks::Online::Model::IntuitType
        xml_accessor :employee_id, :from => 'EmployeeId', :as => Quickeebooks::Online::Model::Id
        xml_accessor :employee_name, :from => 'EmployeeName'
      end
    end
  end
end
