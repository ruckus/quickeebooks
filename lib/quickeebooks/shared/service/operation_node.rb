require 'securerandom'

module Quickeebooks
  module Shared
    module Service

      class OperationNode

        def add(&block)
          node("Add", &block)
        end

        def mod(&block)
          node("Mod", &block)
        end

        def guid
          SecureRandom.hex(16)
        end

        private

        def node(type, &block)
          content = %Q{<#{type} xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"}
          content << %Q{ RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">}
          block.call(content)
          content << "</#{type}>"
          content
        end

      end

    end
  end
end
