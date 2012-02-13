require "quickeebooks"

module Quickeebooks
  
  module Model
    class Email < IntuitType
      xml_accessor :address, :from => 'Address'
    end
  end
end