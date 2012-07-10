require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/payment'
require 'quickeebooks/online/model/payment_header'
require 'quickeebooks/online/model/payment_line_item'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class Payment < ServiceBase

        def create(payment)
          raise InvalidModelException unless payment.valid?
          xml = payment.to_xml_ns
          response = do_http_post(url_for_resource("payment"), valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Payment.from_xml(response.body)
          else
            nil
          end
        end

        def fetch_by_id(id)
          url = "#{url_for_resource("payment")}/#{id}"
          response = do_http_get(url)
          if response && response.code.to_i == 200
            Quickeebooks::Online::Model::Payment.from_xml(response.body)
          else
            nil
          end
        end

        def update(payment)
          raise InvalidModelException.new("Missing required parameters for update") unless payment.valid_for_update?
          url = "#{url_for_resource("payment")}/#{payment.id}"
          xml = payment.to_xml_ns
          response = do_http_post(url, valid_xml_document(xml))
          if response.code.to_i == 200
            Quickeebooks::Online::Model::Payment.from_xml(response.body)
          else
            nil
          end
        end

        def delete(payment)
          raise InvalidModelException.new("Missing required parameters for delete") unless payment.valid_for_deletion?
          xml = valid_xml_document(payment.to_xml_ns(:fields => ['Id', 'SyncToken']))
          url = "#{url_for_resource("payment")}/#{payment.id}"
          response = do_http_post(url, xml, {:methodx => "delete"})
          response.code.to_i == 200
        end

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          fetch_collection("payments", "Payment", Quickeebooks::Online::Model::Payment, filters, page, per_page, sort, options)
        end

      end
    end
  end
end