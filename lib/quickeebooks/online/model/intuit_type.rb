module Quickeebooks
  module Online
    module Model
      class IntuitType
        include ROXML

        private

        # ROXML doesnt insert the namespaces into generated XML so we need to do it ourselves
        # insert the static namespaces in the first opening tag that matches the +model_name+
        def to_xml_inject_ns(model_name, options = {})
          s = StringIO.new
          xml = to_xml(options).write_to(s, :indent => 0, :indent_text => '')
          s.string.sub("<#{model_name}>", "<#{model_name} #{Quickeebooks::Online::Service::ServiceBase::XML_NS}>")
        end

        def log(msg)
          Quickeebooks.logger.info(msg)
          Quickeebooks.logger.flush if Quickeebooks.logger.respond_to?(:flush)
        end

      end 
    end    
  end
end
