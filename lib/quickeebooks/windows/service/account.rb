require 'quickeebooks/windows/model/account'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Account < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection(Quickeebooks::Windows::Model::Account, nil, filters, page, per_page, sort, options)
        end

        def create(account)
          # XML is a wrapped 'object' where the type is specified as an attribute
          #    <Object xsi:type="Account">
          xml_node = account.to_xml(:name => 'Object')
          xml_node.set_attribute('xsi:type', 'Account')
          xml = <<-XML
          <Add xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestId="#{guid}" xmlns="http://www.intuit.com/sb/cdm/v2">
          <ExternalRealmId>#{self.realm_id}</ExternalRealmId>
          #{xml_node}
          </Add>
          XML
          perform_write(Quickeebooks::Windows::Model::Account, xml)
        end

      end
    end
  end
end