require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CustomerKnow
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.precompile += %w( plain.css )

    config.eager_load_paths << "lib"

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.template_engine false
    end
  end
end
