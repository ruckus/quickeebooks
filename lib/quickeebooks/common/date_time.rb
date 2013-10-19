module Quickeebooks
  module Common
      class DateTime
        include ROXML

        xml_accessor :value, :from => :content

        def to_xml(options = {})
          node_name = options[:name]
          %Q{<#{node_name}>#{formatted_date(value)}</#{node_name}>}
        end

        private

        def formatted_date(datetime)
          ::DateTime.parse(datetime).strftime('%Y-%m-%dT%H:%M:%S%z')
        end

      end
    end
end
