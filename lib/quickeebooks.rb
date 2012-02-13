=begin
require 'rubygems'
require 'roxml'
require './lib/quickbooks'
xml = File.read("customer.xml")
d = Quickbooks::Customer.from_xml(xml)
=end

require 'roxml'

module Quickeebooks

  class IntuitType
    include ROXML
  end 
  
end