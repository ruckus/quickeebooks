require 'quickeebooks/windows/service/service_base'
require 'quickeebooks/windows/model/credit_memo'
require 'quickeebooks/windows/model/credit_memo_header'
require 'quickeebooks/windows/model/credit_memo_line_item'

module Quickeebooks
  module Windows
    module Service
      class CreditMemo < Quickeebooks::Windows::Service::ServiceBase

        # Fetch a +Collection+ of +CreditMemo+ objects
        # Arguments:
        # filters: Array of +Filter+ objects to apply
        # page: +Fixnum+ Starting page
        # per_page: +Fixnum+ How many results to fetch per page
        # sort: +Sort+ object
        # options: +Hash+ extra arguments
        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::CreditMemo, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::CreditMemo::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::CreditMemo, url, {:idDomain => idDomain})
        end

        def create(credit_memo)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="CreditMemo">
          xml_node = credit_memo.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'CreditMemo')
          xml = Quickeebooks::Shared::Service::OperationNode.new.add do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::CreditMemo, xml)
        end

        def update(credit_memo)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="CreditMemo">

          # Intuit requires that some fields are unset / do not exist.
          credit_memo.meta_data = nil
          credit_memo.external_key = nil

          # unset Id fields in addresses
          if credit_memo.header.billing_address
            credit_memo.header.billing_address.id = nil
          end

          if credit_memo.header.shipping_address
            credit_memo.header.shipping_address.id = nil
          end

          xml_node = credit_memo.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'CreditMemo')
          xml = Quickeebooks::Shared::Service::OperationNode.new.mod do |content|
            content << "<ExternalRealmId>#{self.realm_id}</ExternalRealmId>#{xml_node}"
          end
          perform_write(Quickeebooks::Windows::Model::CreditMemo, xml)
        end

      end
    end
  end
end
