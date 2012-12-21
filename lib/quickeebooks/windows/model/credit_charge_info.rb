module Quickeebooks
  module Windows
    module Model
      class CreditChargeInfo  < Quickeebooks::Windows::Model::IntuitType
        xml_name 'CreditChargeInfo'
        xml_accessor :number,                 :from => 'Number'
        xml_accessor :type,                   :from => 'Type'
        xml_accessor :name_on_acct,           :from => 'NameOnAcct'
        xml_accessor :cc_expiration_month,    :from => 'CcExpirMn', :as => Integer
        xml_accessor :cc_expiration_year,     :from => 'CcExpirYr', :as => Integer
        xml_accessor :billing_address_street, :from => 'BillAddrStreet'
        xml_accessor :zip_code,               :from => 'ZipCode'
        xml_accessor :cvv,                    :from => 'Ccv'
      end
    end
  end
end
