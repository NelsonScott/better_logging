require "minimal_logging/version"

module MinimalLogging

  class << self
    attr_accessor :app
    attr_accessor :color_codes

    def setup(app)
      self.app = app
      self.color_codes = make_color_codes
      set_log_level
      apply_log_filters
    end

    def set_log_level
      Rails.logger.level = 1 if minimal_config.change_log_level
    end

    def apply_log_filters
      require "minimal_logging/rails_extensions/action_view_log_subscriber_extension.rb"
      require "minimal_logging/rails_extensions/filter_parameters_extension.rb"
      require "minimal_logging/rails_extensions/log_subscriber_extension.rb"
      require "minimal_logging/rails_extensions/logger_extension.rb"
    end

    def minimal_config
      app.config.minimal_logging
    end

    def quiet_assets?
      minimal_config.quiet_assets
    end

    def assets_regex
      paths = app.config.assets.prefix
      paths = [ %r[\A/{0,2}#{paths}] ]
      /\A(#{paths.join('|')})/
    end

    def make_color_codes
      color_hash = {}
      color_hash[1] = color_hash[2] = :green
      color_hash[3] = :yellow
      color_hash[4] = :red
      color_hash[5] = :light_red

      color_hash
    end
  end

  require 'minimal_logging/railtie' if defined?(Rails)
end
