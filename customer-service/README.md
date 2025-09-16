# README

This README would normally document whatever steps are necessary to get the
application up and running.

this project is a simple microservices architecture using Ruby on Rails, PostgreSQL, RabbitMQ, and Docker. It consists of two services: Order Service and Customer Service. The Order Service handles order creation and management, while the Customer Service manages customer information.

was implemented using hexagonal architecture, which promotes separation of concerns and makes the codebase more maintainable and testable.

Things you may want to cover:

* Ruby version (3.4.5)
* Rails version (8.0.4)
* System dependencies PostgreSQL y RabbitMQ
* Configuration
1. Clone the repository
   ```bash
   git clone https://github.com/Great-Side-Projects/monokera-test.git
   cd monokera-test
    ```
* Database creation - Docker compose create database
* Database initialization - Docker compose initialize (seed) the database
* Deployment instructions
1. Build and run the Docker containers
   ```bash
   docker-compose up
   ```
2. Access the application endpoint
3. Order service endpoint
   ```
   curl --location --request POST 'http://localhost:3001/api/v1/orders' \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "customer_id": "customer@email3.com",
    "product_name": "Laptop prueba hex",
    "quantity": 2,
    "price": "999.83"   
    }'
   ```
   ```
     curl --location --request GET 'http://localhost:3001/api/v1/customer/customer@email3.com/orders'
   ```
4. Customer service endpoint
   ```
    curl --location --request GET 'http://localhost:3000/api/v1/customers/customer@email3.com'    ```
3. Stop the application 
   ```bash
   Press CTRL + C
   ```
   ```
   docker-compose down
   ```
   
* How to run the test suite
1. Run the tests, you need database server running and RabbitMQ server running
2. Order service tests
   ```bash
    cd order-service
    bundle install
    rails db:prepare RAILS_ENV=test
   ```
    ```bash
    rails test
    ```
3. Customer service tests
4. ```bash
    cd customer-service
    bundle install
    rails db:prepare RAILS_ENV=test
   ```
    ```bash
    rails test
    ```
# Diagrams
## Hexagonal architecture
   ![architecture](./docs/hexagonal-architecture.png)
# Services communication
   ![services-communication](./docs/services-communication.png)
* The services communicate using RabbitMQ as a message broker. When an order is created in the Order Service, it sends a message to the RabbitMQ queue. The Customer Service listens to this queue and processes the messages to update customer information accordingly.

# Roadmap
* Circuit brakers for inter-service communication http
* Outbox pattern for message reliability
* Dead letter queue for failed messages
* gRPC for inter-service communication
