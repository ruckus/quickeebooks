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
      node = XML.new_node([params[:namespace], params[:name]].compact.join(':')).tap do |root|
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

#== Shared

# Services
require 'quickeebooks/shared/service/filter'
require 'quickeebooks/shared/service/access_token'

#== Online

# Models
require 'quickeebooks/online/model/intuit_type'
require 'quickeebooks/online/model/company_meta_data'
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
require 'quickeebooks/online/service/company_meta_data'
require 'quickeebooks/online/service/customer'
require 'quickeebooks/online/service/account'
require 'quickeebooks/online/service/invoice'
require 'quickeebooks/online/service/item'
require 'quickeebooks/online/service/entitlement'
require 'quickeebooks/online/service/payment'
require 'quickeebooks/online/service/access_token'

#== Windows

# Models
require 'quickeebooks/windows/model/intuit_type'
require 'quickeebooks/windows/model/id'
require 'quickeebooks/windows/model/custom_field'
require 'quickeebooks/windows/model/price'
require 'quickeebooks/windows/model/customer'
require 'quickeebooks/windows/model/account'
require 'quickeebooks/windows/model/item'
require 'quickeebooks/windows/model/invoice'
require 'quickeebooks/windows/model/invoice_header'
require 'quickeebooks/windows/model/invoice_line_item'
require 'quickeebooks/windows/model/address'
require 'quickeebooks/windows/model/rest_response'
require 'quickeebooks/windows/model/success'
require 'quickeebooks/windows/model/error'
require 'quickeebooks/windows/model/object_ref'
require 'quickeebooks/windows/model/sales_rep'
require 'quickeebooks/windows/model/vendor'
require 'quickeebooks/windows/model/vendor_id'
require 'quickeebooks/windows/model/external_key'
require 'quickeebooks/windows/model/ship_method'
require 'quickeebooks/windows/model/sales_tax'
require 'quickeebooks/windows/model/customer_msg'
require 'quickeebooks/windows/model/company_meta_data'
require 'quickeebooks/windows/model/payment'
require 'quickeebooks/windows/model/payment_header'
require 'quickeebooks/windows/model/payment_line_item'
require 'quickeebooks/windows/model/payment_detail'
require 'quickeebooks/windows/model/credit_card'
require 'quickeebooks/windows/model/credit_charge_info'
require 'quickeebooks/windows/model/credit_charge_response'
require 'quickeebooks/windows/model/clazz'
require 'quickeebooks/windows/model/sales_receipt_header'
require 'quickeebooks/windows/model/sales_receipt_line_item'
require 'quickeebooks/windows/model/sales_receipt'
require 'quickeebooks/windows/model/payment_method'


# Services
require 'quickeebooks/windows/service/filter'
require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/service/account'
require 'quickeebooks/windows/service/customer'
require 'quickeebooks/windows/service/item'
require 'quickeebooks/windows/service/invoice'
require 'quickeebooks/windows/service/sales_rep'
require 'quickeebooks/windows/service/sales_receipt'
require 'quickeebooks/windows/service/ship_method'
require 'quickeebooks/windows/service/sales_tax'
require 'quickeebooks/windows/service/customer_msg'
require 'quickeebooks/windows/service/company_meta_data'
require 'quickeebooks/windows/service/payment'
require 'quickeebooks/windows/service/payment_method'
require 'quickeebooks/windows/service/clazz'
require 'quickeebooks/windows/service/access_token'
