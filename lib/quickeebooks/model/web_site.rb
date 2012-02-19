require "quickeebooks"

module Quickeebooks
  module Model
    class WebSite < IntuitType
      xml_accessor :uri, :from => 'URI'
      
      def to_xml(options = {})
        return "" if uri.to_s.empty?
      end
      
    end
  end
end