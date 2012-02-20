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
=begin
        s1 = <<-XML
        <Customer>
          <Id idDomain="QBO">#{id}</Id>
          <SyncToken>0</SyncToken>
          <MetaData>
            <CreateTime>2011-09-29T15:45:12-07:00</CreateTime>
            <LastUpdatedTime>2012-01-22T20:35:57-08:00</LastUpdatedTime>
          </MetaData>
          <Name>John DoeA</Name>
          <Address>
            <Line1>123 Main St.</Line1>
            <Line2>Suite 400</Line2>
            <City>San Diego</City>
            <Country>USA</Country>
            <CountrySubDivisionCode>CA</CountrySubDivisionCode>
            <PostalCode>96009</PostalCode>
            <Tag>Billing</Tag>
          </Address>
          <Address>
            <Line1>123 Main St.</Line1>
            <Line2>Suite 400</Line2>
            <City>San Diego</City>
            <Country>USA</Country>
            <CountrySubDivisionCode>CA</CountrySubDivisionCode>
            <PostalCode>96009</PostalCode>
            <Tag>Shipping</Tag>
          </Address>
          </Customer>
        XML
        s = <<-XML
        <Customer xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://www.intuit.com/sb/cdm/v2" xmlns:ns3="http://www.intuit.com/sb/cdm">
        <Id>5</Id>
        <SyncToken>1</SyncToken>
        <Name>John DoeA</Name>
        <MetaData>
        <CreateTime>2012-02-15T20:27:03-0800</CreateTime>
        <LastUpdatedTime>2012-02-18T21:56:59-0800</LastUpdatedTime>
        </MetaData>
        <Address>
        <Line1>123 Main St.</Line1>
        <Line2>Suite 400</Line2>
        <City>San Diego</City>
        <Country>USA</Country>
        <CountrySubDivisionCode>CA</CountrySubDivisionCode>
        <PostalCode>96009</PostalCode>
        <Tag>Billing</Tag>
        </Address>
        <Address>
        <Line1>123 Main St.</Line1>
        <Line2>Suite 400</Line2>
        <City>San Diego</City>
        <Country>USA</Country>
        <CountrySubDivisionCode>CA</CountrySubDivisionCode>
        <PostalCode>96009</PostalCode>
        <Tag>Shipping</Tag>
        </Address>
        <CustomField xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="StringTypeCustomField">
        <DefinitionId>Preferred Delivery Method</DefinitionId>
        <Value>Email</Value>
        </CustomField>
        <CustomField xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="BooleanTypeCustomeField">
        <DefinitionId>Bill With Parent</DefinitionId>
        <Value>false</Value>
        </CustomField>
        </Customer>
        XML
        #s.sub("<#{model_name}>", "<#{model_name} #{Quickeebooks::Service::ServiceBase::XML_NS}>")
        s
=end
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