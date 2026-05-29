require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Apphitachi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_record.index_nested_attribute_errors = true
    
    #new
    config.time_zone = 'America/Lima'
    config.active_record.default_timezone = :local
    #old
    #config.time_zone = 'Lima'
    #config.active_record.default_timezone = :local
    config.active_record.use_yaml_unsafe_load = true

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    
    Dir.glob("#{Rails.root}/color_admin_v5.1.3/assets/**/").each do |path|
          config.assets.paths << path
    end

        
  end
end
