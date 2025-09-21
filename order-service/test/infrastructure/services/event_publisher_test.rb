     # frozen_string_literal: true

require "test_helper"
require "minitest/autorun"
require_relative "../../../app/infrastructure/services/event_publisher"
require "ostruct"

module Infrastructure
  module Services
    class EventPublisherTest < Minitest::Test
      extend ActiveSupport::Testing::Declarative

      def setup
        @channel_mock = Minitest::Mock.new
        @exchange_mock = Minitest::Mock.new
        @logger_mock = Minitest::Mock.new
        @publisher = EventPublisher.new(channel: @channel_mock)
      end

      def teardown
        [@channel_mock, @exchange_mock].each(&:verify)
      end

      test "publish order created publishes with correct parameters" do
        order_model = create_mock_order(order_id: 1, customer_id: "customer@email3.com")

        @channel_mock.expect(:topic, @exchange_mock) do |name, options|
          name == "orders_exchange" && options == { durable: true }
        end
        @exchange_mock.expect(:publish, nil) do |json, opts|
          json == '{"order_id":1,"customer_id":"customer@email3.com"}' && opts == { routing_key: "order.created" }
        end

        @publisher.publish_order_created(order_model)
      end

      test "publish order created handles errors and re-raises" do
        order_model = create_mock_order(order_id: 1, customer_id: "customer@email3.com")
        error_message = "Connection failed"

        @channel_mock.expect(:topic, nil) do |name, options|
          raise StandardError.new(error_message)
        end

        # Mock Rails.logger for error logging
        @logger_mock.expect(:error, nil, ["Failed to publish order created event: #{error_message}"])

        Rails.stub(:logger, @logger_mock) do
          assert_raises(StandardError) do
            @publisher.publish_order_created(order_model)
          end
        end

        @logger_mock.verify
      end

      private

      def create_mock_order(order_id:, customer_id:)

        order_data = OpenStruct.new(order_id: order_id, customer_id: customer_id)
        order_data.define_singleton_method(:to_json) do
          JSON.generate({ order_id: self.order_id, customer_id: self.customer_id})
        end
        order_data
      end
    end
  end
end