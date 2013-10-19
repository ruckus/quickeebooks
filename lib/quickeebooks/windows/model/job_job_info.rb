require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class JobJobInfo < IntuitType
        xml_accessor :status, :from => 'Status'
        xml_accessor :start_date, :from => 'StartDate'
        xml_accessor :projected_end_date, :from => 'ProjectedEndDate'
        xml_accessor :end_date, :from => 'EndDate'
        xml_accessor :description, :from => 'Description'
        xml_accessor :job_type_id, :from => 'JobTypeId'
      end
    end
  end
end
