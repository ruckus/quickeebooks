require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Customer < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::Customer, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Customer::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Customer, url, {:idDomain => idDomain})
        end

        def create(customer)
          raise InvalidModelException unless customer.valid_for_create?

          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">
          xml_node = customer.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Customer')
          xml = Quickeebooks::Shared::Service::OperationNode.new.add do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::Customer, xml)
        end

        def update(customer)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Invoice">

          # Intuit requires that some fields are unset / do not exist.
          customer.meta_data = nil
          customer.external_key = nil

          # unset Id fields in addresses, phones, email
          if customer.addresses
            customer.addresses.each {|address| address.id = nil }
          end
          if customer.email
            customer.email.id = nil
          end

          if customer.phones
            customer.phones.each {|phone| phone.id = nil }
          end

          if customer.web_site
            customer.web_site.id = nil
          end

          xml_node = customer.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Customer')
          xml = Quickeebooks::Shared::Service::OperationNode.new.mod do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::Customer, xml)
        end

      end
    end
  end
end
