# frozen_string_literal: true

module Domain
  module Port
    module CustomerService
      def find_customer(customer_id)
        raise NotImplementedError
      end
    end
  end
end
