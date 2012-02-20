require 'quickeebooks/model/item'
require 'quickeebooks/service/service_base'

module Quickeebooks
  module Service
    class Item < ServiceBase
      
      def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
        fetch_collection("items", "Item", Quickeebooks::Model::Item, filters, page, per_page, sort, options)
      end

      def create(item)
        raise InvalidModelException unless item.valid?
        xml = item.to_xml_ns
        response = do_http_post(url_for_resource("item"), valid_xml_document(xml))
        if response && response.code.to_i == 200
          Quickeebooks::Model::Item.from_xml(response.body)
        else
          nil
        end
      end
      
      def update(item)
        raise InvalidModelException unless item.valid?
        xml = item.to_xml_ns
        url = "#{url_for_resource("item")}/#{item.id}"
        response = do_http_post(url, valid_xml_document(xml))
        if response && response.code.to_i == 200
          Quickeebooks::Model::Item.from_xml(response.body)
        else
          nil
        end
      end
      
      def fetch_by_id(id)
        response = do_http_get("#{url_for_resource("item")}/#{id}")
        Quickeebooks::Model::Item.from_xml(response.body)
      end

      def delete(item)
        raise InvalidModelException.new("Missing required parameters for delete") unless item.valid_for_deletion?
        xml = valid_xml_document(item.to_xml_ns(:fields => ['Id', 'SyncToken']))
        url = "#{url_for_resource("item")}/#{item.id}"
        response = do_http_post(url, xml, {:methodx => "delete"})
        response.code.to_i == 200
      end
      
    end
  end
end