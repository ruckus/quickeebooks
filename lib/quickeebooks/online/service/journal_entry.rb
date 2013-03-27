require 'quickeebooks/online/service/service_base'
require 'quickeebooks/online/model/journal_entry'
require 'quickeebooks/online/model/journal_entry_header'
require 'quickeebooks/online/model/journal_entry_line_item'
require 'quickeebooks/common/service_crud'
require 'nokogiri'

module Quickeebooks
  module Online
    module Service
      class JournalEntry < ServiceBase
        include ServiceCRUD
      end
    end
  end
end
