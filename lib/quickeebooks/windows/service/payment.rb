require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/payment'
require 'quickeebooks/windows/model/payment_header'
require 'quickeebooks/windows/model/payment_line_item'
require 'quickeebooks/windows/model/payment_detail'
require 'quickeebooks/windows/model/credit_card'
require 'quickeebooks/windows/model/credit_charge_info'
require 'quickeebooks/windows/model/credit_charge_response'
require 'nokogiri'

module Quickeebooks
  module Windows
    module Service
      class Payment < ServiceBase
        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Payment::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Payment, url, { :idDomain => idDomain })
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::Payment, nil, filters, page, per_page, sort, options)
        end

        def create(payment)
          raise InvalidModelException unless payment.valid_for_create?

          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">
          xml_node = payment.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Payment')
          xml = Quickeebooks::Shared::Service::OperationNode.new.add do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::Payment, xml)
        end

      end
    end
  end
end
