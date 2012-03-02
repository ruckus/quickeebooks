require 'roxml'
require 'nokogiri'
require 'logger'
require 'active_model'

class InvalidModelException < Exception; end

module Quickeebooks
  @@logger = nil
  
  def self.logger
    @@logger || Logger.new($stdout) # TODO: replace with a real log file
  end
  
  def self.logger=(logger)
    @@logger = logger
  end
  
  module Model
    class IntuitType
      include ROXML

      private
      
      # ROXML doesnt insert the namespaces into generated XML so we need to do it ourselves
      # insert the static namespaces in the first opening tag that matches the +model_name+
      def to_xml_inject_ns(model_name, options = {})
        s = StringIO.new
        xml = to_xml(options).write_to(s, :indent => 0, :indent_text => '')
        s.string.sub("<#{model_name}>", "<#{model_name} #{Quickeebooks::Service::ServiceBase::XML_NS}>")
      end
      
      def log(msg)
        Quickeebooks.logger.info(msg)
        Quickeebooks.logger.flush if Quickeebooks.logger.respond_to?(:flush)
      end
        
    end 
  end
  
  class Collection
    attr_accessor :entries, :count, :current_page
  end
  
end

# monkey-path the to_xml method to add support for passing
# in a list of attributes that we want generated rather than the complete set
# This allows us to construct sub-object representations.
module ROXML
  module InstanceMethods # :nodoc:
    # Returns an XML object representing this object
    def to_xml(params = {})
      params[:fields] ||= []
      params.reverse_merge!(:name => self.class.tag_name, :namespace => self.class.roxml_namespace)
      params[:namespace] = nil if ['*', 'xmlns'].include?(params[:namespace])
      XML.new_node([params[:namespace], params[:name]].compact.join(':')).tap do |root|
        refs = (self.roxml_references.present? \
          ? self.roxml_references \
          : self.class.roxml_attrs.map {|attr| attr.to_ref(self) })
        
        if params[:fields].length > 0
          refs.reject! { |r| !params[:fields].include?(r.name) }
        end
        refs.each do |ref|
          value = ref.to_xml(self)
          unless value.nil?
            ref.update_xml(root, value)
          end
        end
      end
    end
  end  
end

# Models
require 'quickeebooks/model/customer'
require 'quickeebooks/model/account'
require 'quickeebooks/model/invoice'
require 'quickeebooks/model/invoice_header'
require 'quickeebooks/model/invoice_line_item'
require 'quickeebooks/model/item'
require 'quickeebooks/model/unit_price'
require 'quickeebooks/model/meta_data'
require 'quickeebooks/model/price'
require 'quickeebooks/model/account_reference'



# Services
require 'quickeebooks/service/filter'
require 'quickeebooks/service/pagination'
require 'quickeebooks/service/sort'
require 'quickeebooks/service/customer'
require 'quickeebooks/service/account'
require 'quickeebooks/service/invoice'
require 'quickeebooks/service/item'
require 'quickeebooks/service/entitlement'