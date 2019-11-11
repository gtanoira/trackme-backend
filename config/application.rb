require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.channel         assets: false
    end

    # Mailer: se agregó la configuración SMTP para poder enviar mails desde localhost
    ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.gmail.com',
      :domain         => 'mail.google.com',
      :port           => 587,
      :user_name      => 'gonzalo.mtanoira@gmail.com',   #ENV['GMAIL_USERNAME']
      :password       => 'WalkingTheNow',  # ENV['GMAIL_PASSWORD']
      :authentication => 'plain',
      :enable_starttls_auto => true
    }

    # CORS: cross-origin for Angular
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :patch, :options]
      end
    end

  end
end
