# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OopCore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.hosts.clear

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.oop = {
      services_token: ENV['OOP_CORE_TOKEN'],
      renderer_path: ENV['OOP_RENDERER_PATH'],
      interface: {
        scheme: ENV['OOP_CORE_INTERFACE_SCHEME'],
        port: ENV['OOP_CORE_INTERFACE_PORT'],
        path: ENV['OOP_CORE_INTERFACE_PATH']
      },
      rabbit: {
        devices_exchange: ENV['OOP_CORE_DEVICE_UPDATE_EXCHANGE'],
        response_queue: ENV['OOP_CORE_RESPONSE_Q']
      },
      from_email: ENV['OOP_CORE_FROM_ADDRESS'],
      smtp: {
        address:  ENV['OOP_CORE_SMTP_ADDRESS'],
        port: ENV['OOP_CORE_SMTP_PORT'],
        domain: ENV['OOP_CORE_SMTP_DOMAIN'],
        user_name: ENV['OOP_CORE_SMTP_USER_NAME'],
        password: ENV['OOP_CORE_SMTP_PASSWORD'],
        authentication: ENV['OOP_CORE_SMTP_AUTHENTICATION'],
        enable_starttls_auto: ENV['OOP_CORE_SMTP_ENABLE_STARTTLS_AUTO']
      }
    }
  end
end
