require 'quickeebooks/windows/model/status'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Status < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          custom_field_query = '<?xml version="1.0" encoding="utf-8"?>'
          custom_field_query += '<SyncStatusRequest ErroredObjectsOnly="true" xmlns="http://www.intuit.com/sb/cdm/v2">'
          #Apparently it doesn't like limiting down to an ID
          #custom_field_query += '<SyncStatusParam><IdSet>'
          #custom_field_query += '<Id idDomain="QB">458746</Id>'
          #custom_field_query += '</IdSet><ObjectType>SalesReceipt</ObjectType></SyncStatusParam>'
          custom_field_query += '</SyncStatusRequest>'
          fetch_collection(Quickeebooks::Windows::Model::Status, custom_field_query.strip, filters, page, per_page, sort, options)
        end
      end
    end
  end
end