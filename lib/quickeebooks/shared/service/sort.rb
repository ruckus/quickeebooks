module Quickeebooks
  module Shared
    module Service
      class Sort
        attr_accessor :field, :how

        def initialize(field, how)
          @field = field
          @how = how
        end

        def to_s
          "#{field} #{how}"
        end

        def to_xml
          "<SortByColumn sortOrder=\"#{how}\">#{field}</SortByColumn>"
        end
      end
    end
  end
end
