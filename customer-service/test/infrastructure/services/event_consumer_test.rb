# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require "sneakers"
require_relative '../../../app/infrastructure/services/event_consumer'
require "active_support/testing/declarative"

# Define Rails module for testing if it doesn't exist
unless defined?(Rails)
  Rails = Module.new
  Rails.define_singleton_method(:logger) { nil }
end

class Infrastructure::Services::EventConsumerTest < Minitest::Test
  extend ActiveSupport::Testing::Declarative

  def setup
    @repository_mock = Minitest::Mock.new
    @consumer = Infrastructure::Services::EventConsumer.new
    Infrastructure::Services::EventConsumer.customer_repository = @repository_mock
    @logger_mock = Minitest::Mock.new
  end

  def teardown
    @repository_mock.verify
    Infrastructure::Services::EventConsumer.customer_repository = nil
  end

  test "work processes valid message and calls repository" do
    customer_id = 123
    message = { "customer_id" => customer_id }.to_json
    ack_called = false

    @repository_mock.expect :increment_customer_order_count, nil, [customer_id]
    @logger_mock.expect :info, nil, [String]

    Rails.stub :logger, @logger_mock do
      @consumer.stub :ack!, -> { ack_called = true } do
        @consumer.work(message)
      end
    end

    assert ack_called
    @logger_mock.verify
  end

  test "work processes message with string customer_id" do
    customer_id = "456"
    message = { "customer_id" => customer_id }.to_json
    ack_called = false

    @repository_mock.expect :increment_customer_order_count, nil, [customer_id]
    @logger_mock.expect :info, nil, [String]

    Rails.stub :logger, @logger_mock do
      @consumer.stub :ack!, -> { ack_called = true } do
        @consumer.work(message)
      end
    end

    assert ack_called
    @logger_mock.verify
  end

  test "work handles invalid JSON and calls reject!" do
    invalid_message = "invalid json"
    reject_called = false

    @logger_mock.expect :error, nil, [String]

    Rails.stub :logger, @logger_mock do
      @consumer.stub :reject!, -> { reject_called = true } do
        @consumer.work(invalid_message)
      end
    end

    assert reject_called
    @logger_mock.verify
  end

  test "customer_repository class accessor works" do
    test_repo = Object.new
    Infrastructure::Services::EventConsumer.customer_repository = test_repo

    assert_same test_repo, Infrastructure::Services::EventConsumer.customer_repository
  end
end