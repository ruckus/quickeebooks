require 'quickeebooks'
require 'time'

module Quickeebooks

  class MetaData < IntuitType
    xml_accessor :create_time, :from => 'CreateTime', :as => Time
    xml_accessor :last_updated_time, :from => 'LastUpdatedTime', :as => Time
  end
end