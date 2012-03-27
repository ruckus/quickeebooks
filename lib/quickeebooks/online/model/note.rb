require 'quickeebooks'

module Quickeebooks
  module Online
    module Model
      class Note < Quickeebooks::Online::Model::IntuitType
        xml_accessor :content, :from => 'Content'
      end
    end
  end
end
