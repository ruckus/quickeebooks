module Quickeebooks
  module Online
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

      end
    end
  end
end