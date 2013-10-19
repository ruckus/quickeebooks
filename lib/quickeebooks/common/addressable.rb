module Quickeebooks
  module Model
    module Addressable

      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
      end

      module InstanceMethods
        def phone=(phone)
          self.phones ||= []
          self.phones << phone
        end

        def address=(address)
          self.addresses ||= []
          self.addresses << address
        end

        def billing_address
          select_address("Billing")
        end

        def shipping_address
          select_address("Shipping")
        end

        def primary_phone
          select_phone("Primary")
        end

        def secondary_phone
          select_phone("Secondary")
        end

        def mobile_phone
          select_phone("Mobile")
        end

        def fax
          select_phone("Fax")
        end

        def pager
          select_phone("Pager")
        end

        private

        def select_phone(type)
          phones.detect { |phone| phone.device_type == type }
        end

        def select_address(tag)
          addresses.detect { |address| address.tag == tag }
        end

      end # InstanceMethods

    end
  end
end
