module Quickbooks

  class IntuitType
    include Virtus
  end  

  class Metadata < IntuitType
    attribute :CreateTime, DateTime
  end

  class Customer < IntuitType
    attribute :id, String
    attribute :SyncToken, Integer
    attribute :MetaData, Quickbooks::Metadata
  end
  
end

#require './quickbooks/customer'