require 'quickeebooks/windows/model/job'
require 'quickeebooks/windows/service/service_base'

module Quickeebooks
  module Windows
    module Service
      class Job < Quickeebooks::Windows::Service::ServiceBase

        FILTER_ORDER = %w{OfferingId IteratorId StartPage ChunkSize IncludeTagElements CDCAsOf SynchronizedFilter
          DraftFilter ObjectStateEnable CustomFieldEnable CustomFieldQueryParam CustomFieldFilter CustomFieldDefinitionSet
          ListIdSet StartCreatedTMS EndCreatedTMS StartModifiedTMS EndModifiedTMS CustomerIdSet IncludeFinancialIndicator}

        def list(filters = [], page = 1, per_page = 20, sort = nil, options = {})
          filters << Quickeebooks::Shared::Service::Filter.new(:boolean, :field => 'CustomFieldEnable', :value => true)
          fetch_collection(Quickeebooks::Windows::Model::Job, nil, filters, page, per_page, sort, options)
        end

        def fetch_by_id(id, idDomain = 'QB', options = {})
          url = "#{url_for_resource(Quickeebooks::Windows::Model::Job::REST_RESOURCE)}/#{id}"
          fetch_object(Quickeebooks::Windows::Model::Job, url, {:idDomain => idDomain})
        end

      end
    end

  end
end
