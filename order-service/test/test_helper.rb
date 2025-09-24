require "simplecov"
SimpleCov.start "rails" do
  #enable_coverage :branch
  add_filter 'app/controllers/application_controller.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/application_logic/dto'
  add_filter 'app/domain/port'

  add_group "domain", "app/domain/models"
  add_group "application", "app/application_logic/use_cases"
  add_group "infrastructure", "app/infrastructure"
end
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
