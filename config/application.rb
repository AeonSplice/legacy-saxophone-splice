require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SaxophoneSplice
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.sass.preferred_syntax = :sass

    config.use_ssl = true
    config.force_ssl = true

    config.generators do |g|
      g.test_framework = :rspec
      g.fixture_replacement :factory_girl
    end
  end
end
