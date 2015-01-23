# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'vcr'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

VCR.configure do |c|
  c.filter_sensitive_data("<GITHUB_TEST_TOKEN>")     { ENV["GITHUB_TEST_TOKEN"] }
  c.cassette_library_dir = Rails.root.join('spec', 'cassettes')
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

module JsonHelpers
  def response_json
    @response_json ||= JSON.parse(response.body)
  end
end

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include JsonHelpers, type: :controller
  config.include Devise::TestHelpers, type: :controller

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
