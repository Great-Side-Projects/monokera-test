# frozen_string_literal: true

module Domain
  module Port
    module CustomerRepository
      def find_by_customer_id(customer_id)
        raise NotImplementedError
      end
    end
  end
end
