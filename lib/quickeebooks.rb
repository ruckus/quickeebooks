require 'roxml'
require 'nokogiri'
require 'logger'

module Quickeebooks
  @@logger = nil
  
  def self.logger
    @@logger || Logger.new("quickeebooks.log")
  end
  
  def self.logger=(logger)
    @@logger = logger
  end
  
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
          #puts "ref = #{ref.name}"
          value = ref.to_xml(self)
          unless value.nil?
            ref.update_xml(root, value)
          end
        end
      end
    end
  end  
end