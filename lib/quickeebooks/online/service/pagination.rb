module Quickeebooks
  module Online
    module Service
      class Pagination
        attr_accessor :page, :results_per_page

        def initialize(page, results_per_page)
          @page = page
          @results_per_page = results_per_page
        end

        def to_s
          "PageNum=#{@page}\nResultsPerPage=#{@results_per_page}"
        end

      end
    end
  end
end
