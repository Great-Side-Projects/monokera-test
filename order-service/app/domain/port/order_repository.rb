# frozen_string_literal: true

module Domain
  module Port
    module OrderRepository
      def find_by_customer_id(customer_id)
        raise NotImplementedError
      end

      def save(order_model)
        raise NotImplementedError
      end
    end
  end
end
