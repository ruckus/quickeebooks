module Quickeebooks
  module Windows
    module Model
      class IntuitType
        include ROXML

        private

        def log(msg)
          Quickeebooks.logger.info(msg)
          Quickeebooks.logger.flush if Quickeebooks.logger.respond_to?(:flush)
        end

      end 
    end    
  end
end
