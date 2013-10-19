module OnlineEntityModel

  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods
    base.class_eval do
      xml_convention :camelcase
      xml_accessor :id, :from => 'Id', :as => Quickeebooks::Online::Model::Id
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :name, :from => 'Name'
      xml_accessor :meta_data, :from => 'MetaData', :as => Quickeebooks::Online::Model::MetaData
      xml_accessor :addresses, :from => 'Address', :as => [Quickeebooks::Online::Model::Address]
      xml_accessor :email, :from => 'Email', :as => Quickeebooks::Online::Model::Email
      xml_accessor :phones, :from => 'Phone', :as => [Quickeebooks::Online::Model::Phone]
      xml_accessor :web_site, :from => 'WebSite', :as => Quickeebooks::Online::Model::WebSite
      xml_accessor :given_name, :from => 'GivenName'
      xml_accessor :middle_name, :from => 'MiddleName'
      xml_accessor :family_name, :from => 'FamilyName'
      xml_accessor :suffix, :from => 'Suffix'
      xml_accessor :gender, :from => 'Gender'
      xml_accessor :dba_name, :from => 'DBAName'
      xml_accessor :show_as, :from => 'ShowAs'
      xml_accessor :tax_identifier, :from => 'TaxIdentifier'
      xml_accessor :sales_term_id, :from => 'SalesTermId', :as => Quickeebooks::Online::Model::Id
      xml_accessor :open_balance, :from => 'OpenBalance', :as => Quickeebooks::Online::Model::OpenBalance
      xml_accessor :external_id, :from => 'ExternalId'
    end
  end


  module InstanceMethods
    def valid_for_update?
      if sync_token.nil?
        errors.add(:sync_token, "Missing required attribute SyncToken for update")
      end
      errors.empty?
    end

    def to_xml_ns(options = {})
      to_xml_inject_ns(self.class::XML_NODE, options)
    end

    def email_address=(email_address)
      self.email = Quickeebooks::Online::Model::Email.new(email_address)
    end

    # To delete an account Intuit requires we provide Id and SyncToken fields
    def valid_for_deletion?
      return false if(id.nil? || sync_token.nil?)
      id.value.to_i > 0 && !sync_token.to_s.empty? && sync_token.to_i >= 0
    end
  end

  module ClassMethods
  end

end
