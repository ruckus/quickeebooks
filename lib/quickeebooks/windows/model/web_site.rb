require "quickeebooks"

module Quickeebooks
  module Windows
    module Model
      class WebSite < Quickeebooks::Windows::Model::IntuitType
        xml_accessor :id, :from => 'Id'
        xml_accessor :uri, :from => 'URI'
        xml_accessor :tag, :from => 'Tag'
        xml_accessor :default, :from => 'Default'

        def to_xml(options = {})
          return "" if uri.to_s.empty?
        end

      end
    end
  end
end