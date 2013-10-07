require "quickeebooks"

module Quickeebooks
  module Online
    module Model
      class WebSite < Quickeebooks::Online::Model::IntuitType
        xml_accessor :uri, :from => 'URI'

        def initialize(uri = nil)
          self.uri = uri if uri
        end
        
        def to_xml(options = {})
          return "" if uri.to_s.empty?
          super(options)
        end

      end
    end
  end
end