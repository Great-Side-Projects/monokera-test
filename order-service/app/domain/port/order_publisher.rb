# frozen_string_literal: true

module Domain
  module Port
    module OrderPublisher
      def publish_order_created(order_model)
        raise NotImplementedError
      end
      def get(path)
        raise NotImplementedError
      end
    end
  end
end
