require 'quickeebooks'

module Quickeebooks

  module Model
    class Note < IntuitType
      xml_accessor :content, :from => 'Content'
    end
  end
  
end
