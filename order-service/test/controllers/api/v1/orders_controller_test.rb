require "test_helper"
require "minitest/mock"
require_relative "../../../../app/infrastructure/repositories/active_record_order_repository"
require_relative "../../../../app/infrastructure/services/customer_api_service"
require_relative "../../../../app/infrastructure/services/event_publisher"
require_relative "../../../../app/application_logic/use_cases/create_order"
require_relative "../../../../app/application_logic/use_cases/get_customer_orders"
require_relative "../../../../app/application_logic/dto/create_order_request"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @valid_order_params = {
      customer_id: 1,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99
    }

    # Mock dependencies
    @mock_repository = Minitest::Mock.new
    @mock_customer_service = Minitest::Mock.new
    @mock_event_publisher = Minitest::Mock.new
    @mock_create_order = Minitest::Mock.new
    @mock_get_customer_orders = Minitest::Mock.new

    # Stub dependency creation
    Infrastructure::Repositories::ActiveRecordOrderRepository.stub :new, @mock_repository do
      Infrastructure::Services::CustomerApiService.stub :new, @mock_customer_service do
        Infrastructure::Services::EventPublisher.stub :new, @mock_event_publisher do
          ApplicationLogic::UseCases::CreateOrder.stub :new, @mock_create_order do
            ApplicationLogic::UseCases::GetCustomerOrders.stub :new, @mock_get_customer_orders do
              # Tests will run here
            end
          end
        end
      end
    end
  end

  def teardown
    @mock_repository.verify if @mock_repository
    @mock_customer_service.verify if @mock_customer_service
    @mock_event_publisher.verify if @mock_event_publisher
    @mock_create_order.verify if @mock_create_order
    @mock_get_customer_orders.verify if @mock_get_customer_orders
  end

  test "should create order with valid params and return created order" do
    expected_response = {
      id: 123,
      customer_id: 1,
      product_name: "Test Product",
      quantity: 2,
      price: 99.99,
      total: 199.98,
      status: "pending"
    }

    @mock_create_order.expect :execute, expected_response, [Object]

    Infrastructure::Repositories::ActiveRecordOrderRepository.stub :new, @mock_repository do
      Infrastructure::Services::CustomerApiService.stub :new, @mock_customer_service do
        Infrastructure::Services::EventPublisher.stub :new, @mock_event_publisher do
          ApplicationLogic::UseCases::CreateOrder.stub :new, @mock_create_order do
            post api_v1_orders_url, params: @valid_order_params, as: :json
          end
        end
      end
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 123, json_response["id"]
    assert_equal "Test Product", json_response["product_name"]
  end

  test "should handle create order use case exception" do
    @mock_create_order.expect(:execute, nil) do
          raise StandardError.new("Customer not found")
        end
    Infrastructure::Repositories::ActiveRecordOrderRepository.stub :new, @mock_repository do
      Infrastructure::Services::CustomerApiService.stub :new, @mock_customer_service do
        Infrastructure::Services::EventPublisher.stub :new, @mock_event_publisher do
          ApplicationLogic::UseCases::CreateOrder.stub :new, @mock_create_order do
            assert_raises StandardError do
              post api_v1_orders_url, params: @valid_order_params, as: :json
            end
          end
        end
      end
    end
  end

  test "should show orders by customer id with mock data" do
    customer_id = 1
    expected_orders = [
      {
        customer_id: 1,
        product_name: "Product A",
        quantity: 1,
        price: 50.0,
        total: 50.0,
        status: "completed"
      },
      {
        customer_id: 1,
        product_name: "Product B",
        quantity: 2,
        price: 30.0,
        total: 60.0,
        status: "pending"
      }
    ]

    @mock_get_customer_orders.expect :execute, expected_orders, [customer_id.to_s]

    Infrastructure::Repositories::ActiveRecordOrderRepository.stub :new, @mock_repository do
      ApplicationLogic::UseCases::GetCustomerOrders.stub :new, @mock_get_customer_orders do
        get "/api/v1/customer/#{customer_id}/orders", as: :json
      end
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert json_response.is_a?(Array)
    assert_equal 2, json_response.length
    assert_equal "Product A", json_response[0]["product_name"]
  end

  test "should return 404 when no orders found for customer with empty array" do
    customer_id = 999
    @mock_get_customer_orders.expect :execute, [], [customer_id.to_s]

    Infrastructure::Repositories::ActiveRecordOrderRepository.stub :new, @mock_repository do
      ApplicationLogic::UseCases::GetCustomerOrders.stub :new, @mock_get_customer_orders do
        get "/api/v1/customer/#{customer_id}/orders", as: :json
      end
    end

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal "Orders not found", json_response["error"]
  end

  test "should handle get customer orders use case exception" do
    customer_id = 1
    @mock_get_customer_orders.expect :execute, -> { raise StandardError.new("Database error") }, [customer_id.to_s]

    Infrastructure::Repositories::ActiveRecordOrderRepository.stub :new, @mock_repository do
      ApplicationLogic::UseCases::GetCustomerOrders.stub :new, @mock_get_customer_orders do
        assert_raises StandardError do
          get "/api/v1/customer/#{customer_id}/orders", as: :json
        end
      end
    end
  end
end
