require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class TimeActivityEmployee < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :employee_id, :from => 'EmployeeId', :as => Quickeebooks::Windows::Model::Id
        xml_accessor :employee_name, :from => 'EmployeeName'
      end
    end
  end
end
