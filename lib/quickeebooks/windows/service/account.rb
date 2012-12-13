require 'quickeebooks/windows/model/account'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Account < Quickeebooks::Windows::Service::ServiceBase

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          custom_field_query = '<?xml version="1.0" encoding="utf-8"?>'
          custom_field_query += '<AccountQuery xmlns="http://www.intuit.com/sb/cdm/v2">'
          custom_field_query += "<StartPage>#{page}</StartPage><ChunkSize>#{per_page}</ChunkSize>"
          custom_field_query += '<CustomFieldEnable>true</CustomFieldEnable></AccountQuery>'
          fetch_collection(Quickeebooks::Windows::Model::Account, custom_field_query.strip, filters, page, per_page, sort, options)
        end

      end
    end
  end
end