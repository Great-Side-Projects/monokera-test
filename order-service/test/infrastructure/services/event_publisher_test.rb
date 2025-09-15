      # frozen_string_literal: true

      require "test_helper"
      require "minitest/autorun"
      require_relative "../../../app/infrastructure/services/event_publisher"

      module Infrastructure
        module Services
          class EventPublisherTest < Minitest::Test
            extend ActiveSupport::Testing::Declarative
# TODO: check error global
=begin
            def setup
              @connection_mock = Minitest::Mock.new
              @channel_mock = Minitest::Mock.new
              @exchange_mock = Minitest::Mock.new
              @publisher = EventPublisher.new(connection: @connection_mock)
            end

            def teardown
              [@connection_mock, @channel_mock, @exchange_mock].each(&:verify)
            end

            test "publish order created starts connection and creates channel" do
              order_model = create_mock_order('{"id":1,"status":"created"}')

              @connection_mock.expect(:start, nil)
              @connection_mock.expect(:create_channel, @channel_mock)
              @connection_mock.expect(:open?, true)
              @connection_mock.expect(:close, nil)

              @channel_mock.expect(:topic, @exchange_mock) do |name, **options|
                name == "orders_exchange" && options[:durable] == true
              end
              @exchange_mock.expect(:publish, nil) do |json, opts|
                json == '{"id":1,"status":"created"}' && opts == { routing_key: "order.created" }
              end

              @publisher.publish_order_created(order_model)
            end

            test "publish order created closes connection after publishing" do
              order_model = create_mock_order('{"id":2}')

              @connection_mock.expect(:start, nil)
              @connection_mock.expect(:create_channel, @channel_mock)
              @connection_mock.expect(:open?, true)
              @connection_mock.expect(:close, nil)

              @channel_mock.expect(:topic, @exchange_mock) do |name, **options|
                name == "orders_exchange" && options[:durable] == true
              end
              @exchange_mock.expect(:publish, nil) do |json, opts|
                json == '{"id":2}' && opts == { routing_key: "order.created" }
              end

              @publisher.publish_order_created(order_model)
            end

            test "publish order created publishes with correct routing key" do
              order_model = create_mock_order('{"customer_id":123}')

              @connection_mock.expect(:start, nil)
              @connection_mock.expect(:create_channel, @channel_mock)
              @connection_mock.expect(:open?, true)
              @connection_mock.expect(:close, nil)

              @channel_mock.expect(:topic, @exchange_mock) do |name, **options|
                name == "orders_exchange" && options[:durable] == true
              end
              @exchange_mock.expect(:publish, nil) do |json, opts|
                json == '{"customer_id":123}' && opts == { routing_key: "order.created" }
              end

              @publisher.publish_order_created(order_model)
            end

            test "publish order created converts order model to json" do
              json_data = '{"id":4,"customer_id":456,"status":"pending"}'
              order_model = create_mock_order(json_data)

              @connection_mock.expect(:start, nil)
              @connection_mock.expect(:create_channel, @channel_mock)
              @connection_mock.expect(:open?, true)
              @connection_mock.expect(:close, nil)

              @channel_mock.expect(:topic, @exchange_mock) do |name, **options|
                name == "orders_exchange" && options[:durable] == true
              end
              @exchange_mock.expect(:publish, nil) do |json, opts|
                json == json_data && opts == { routing_key: "order.created" }
              end

              @publisher.publish_order_created(order_model)
            end

            private

            def create_mock_order(json_response)
              order_mock = Minitest::Mock.new
              order_mock.expect(:to_json, json_response)

              # Permitir cualquier método interno que Ruby pueda llamar
              def order_mock.method_missing(method, *args)
                if method.to_s.start_with?('instance_variable_')
                  nil
                else
                  super
                end
              end

              def order_mock.respond_to_missing?(method, include_private = false)
                method.to_s.start_with?('instance_variable_') || super
              end

              order_mock
            end
=end
          end
        end
      end