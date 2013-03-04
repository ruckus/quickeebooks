module OnlineLineItemModelMethods

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def initialize
      ensure_line_items_initialization
    end

    def valid_for_update?
      errors.empty?
    end

    def to_xml_ns(options = {})
      to_xml_inject_ns(self.class::XML_NODE, options)
    end

    def valid_for_deletion?
      return false if(id.nil? || sync_token.nil?)
      id.value.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
    end

    private

    def after_parse
    end

    def ensure_line_items_initialization
      self.line_items ||= []
    end
  end

  module ClassMethods
    def resource_for_collection
      "#{self::REST_RESOURCE}s"
    end
  end

end

