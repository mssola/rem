# Set up the test enviroment
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)


# Require everything necessary
require 'rspec/rails'
require 'capybara/rspec'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


# RSpec configuration
RSpec.configure do |config|
  # We are using rspec
  config.mock_with :rspec

  # I'm pretty muck ok with it
  config.use_transactional_fixtures = true

  # Include the Mailer macros and reset the email queue before :each
  config.include(MailerMacros)
  config.before(:each) { reset_email }

  # Include presenters inside the test suite
  config.include ActionView::TestCase::Behavior,
      example_group: {file_path: %r{spec/presenters}}
end
