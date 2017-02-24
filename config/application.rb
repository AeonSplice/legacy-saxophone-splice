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

    # Disabled while I migrate directories in prep for multiple servers
    config.force_ssl = true

    config.generators do |g|
      g.test_framework = :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.stylesheets = false
      g.javascripts = false
    end

    # Timezone Configuration
    config.time_zone = 'UTC'

    # Locale Configuration
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [:en]

    # fallbacks value can also be a hash - a map of fallbacks if you will
    # missing translations of es and fr languages will fallback to english
    # missing translations in german will fallback to french ('de' => 'fr')
    # config.i18n.fallbacks = {'es' => 'en', 'fr' => 'en', 'de' => 'fr'}

    # Disable field_with_errors div
    # config.action_view.field_error_proc = Proc.new  do |html_tag, instance|
    #   html_tag.html_safe
    # end

    # Route errors to the errors controller
    config.exceptions_app = self.routes
  end
end
