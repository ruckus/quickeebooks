require "quickeebooks"

module Quickeebooks
  module Model
    class WebSite < IntuitType
      xml_accessor :uri, :from => 'URI'
    end
  end
end