require 'quickeebooks/windows/model/item'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Item < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          filters << Quickeebooks::Shared::Service::Filter.new(:boolean, :field => 'CustomFieldEnable', :value => true)
          fetch_collection(Quickeebooks::Windows::Model::Item, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Item::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Item, url, {:idDomain => idDomain})
        end

        def create(item)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Item">
          xml_node = item.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Item')
          xml = Quickeebooks::Shared::Service::OperationNode.new.add do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::Item, xml)
        end

      end
    end

  end
end
