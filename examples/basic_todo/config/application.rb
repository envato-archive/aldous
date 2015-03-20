require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BasicTodo
  class Application < Rails::Application
    config.encoding = "utf-8"

    config.exceptions_app = self.routes

    config.generators.assets = false
    config.generators.helper = false

    # Change this to expire all assets
    config.assets.version = '1.0'

    config.action_controller.include_all_helpers = false

    config.action_dispatch.default_headers['X-Frame-Options'] = 'SAMEORIGIN'

    config.autoload_paths += %W(
      #{config.root}/app/views
      #{config.root}/app/services
      #{config.root}/app/controller_services
      #{config.root}/app/controller_actions
      #{config.root}/lib
    )

    config.eager_load_paths += %W(
      #{config.root}/app/views
      #{config.root}/app/services
      #{config.root}/app/controller_services
      #{config.root}/app/controller_actions
      #{config.root}/lib
    )
  end
end
