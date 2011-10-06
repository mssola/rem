require 'rubygems'
require 'spork'


##
# Re-opening the FactoryGirl module
module FactoryGirl
  ##
  # According to some people, FactoryGirl already defines this.
  # However, I had some troubles with it so I defined the reload
  # class method by myself.
  def self.reload
    FactoryGirl.factories.clear
    FactoryGirl.sequences.clear
    FactoryGirl.traits.clear
    FactoryGirl.find_definitions
  end
end


# Things to be loaded before starting the Spork server.
Spork.prefork do
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

    # We can add a focus tag to the test we are focussed on.
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
  end
end

# This code will be run each time you run your specs.
Spork.each_run do
  # We want every factory to be realoaded for each run.
  FactoryGirl.reload
end
