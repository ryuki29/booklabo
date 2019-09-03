require_relative 'boot'

require 'rails/all'
require 'amazon/ecs'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Booklabo
  class Application < Rails::Application
    config.load_defaults 5.2

    Amazon::Ecs.options = {
      associate_tag:     Rails.application.credentials.amazon_api[:associate_tag],
      AWS_access_key_id: Rails.application.credentials.amazon_api[:access_key],
      AWS_secret_key:    Rails.application.credentials.amazon_api[:secret_key]
    }
  end
end
