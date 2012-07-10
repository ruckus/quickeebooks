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

#== Online

# Models
require 'quickeebooks/online/model/intuit_type'
require 'quickeebooks/online/model/customer'
require 'quickeebooks/online/model/account'
require 'quickeebooks/online/model/invoice'
require 'quickeebooks/online/model/invoice_header'
require 'quickeebooks/online/model/invoice_line_item'
require 'quickeebooks/online/model/item'
require 'quickeebooks/online/model/unit_price'
require 'quickeebooks/online/model/meta_data'
require 'quickeebooks/online/model/price'
require 'quickeebooks/online/model/account_reference'
require 'quickeebooks/online/model/payment'
require 'quickeebooks/online/model/payment_header'
require 'quickeebooks/online/model/payment_line_item'
require 'quickeebooks/online/model/payment_detail'
require 'quickeebooks/online/model/credit_card'
require 'quickeebooks/online/model/credit_charge_info'
require 'quickeebooks/online/model/credit_charge_response'

# Services
require 'quickeebooks/online/service/filter'
require 'quickeebooks/online/service/pagination'
require 'quickeebooks/online/service/sort'
require 'quickeebooks/online/service/customer'
require 'quickeebooks/online/service/account'
require 'quickeebooks/online/service/invoice'
require 'quickeebooks/online/service/item'
require 'quickeebooks/online/service/entitlement'
require 'quickeebooks/online/service/payment'

#== Windows
require 'quickeebooks/windows/model/intuit_type'
require 'quickeebooks/windows/model/custom_field'
require 'quickeebooks/windows/model/price'
require 'quickeebooks/windows/model/customer'
require 'quickeebooks/windows/model/account'
require 'quickeebooks/windows/model/item'
require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/service/account'
require 'quickeebooks/windows/service/customer'
require 'quickeebooks/windows/service/item'
