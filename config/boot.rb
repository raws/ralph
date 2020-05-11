module Ralph
  class << self
    attr_accessor :bot, :env, :logger, :root
  end

  def self.boot
    Boot.load_environment
    Boot.initialize_bot
    Boot.load_initializers
    Boot.connect_to_database
  end

  def self.console
    require 'pry'

    boot
    ActiveRecord::Base.logger = Ralph.logger
    binding.pry # rubocop:disable Lint/Debugger
  end

  def self.current_database_config
    database_config_for(Ralph.env)
  end

  def self.database_configs
    if @database_configs
      @database_configs
    else
      require 'erb'
      require 'yaml'

      config_path = Ralph.root.join('config/database.yml')
      rendered_config = ERB.new(config_path.read).result

      # rubocop:disable Security/YAMLLoad
      @database_configs = YAML.load(rendered_config).with_indifferent_access
      # rubocop:enable Security/YAMLLoad
    end
  end

  def self.database_config_for(environment)
    database_configs[environment] || {}
  end

  def self.install_plugin(plugin)
    bot.install_plugin(plugin)
  end

  def self.run
    boot
    bot.run
  end

  module Boot
    AUTOLOAD_PATHS = %w[app/models app/plugins].freeze
    REQUIRED_ENVIRONMENT_VARIABLES = %w[BOT_NAME ZULIP_API_KEY ZULIP_EMAIL ZULIP_HOST].freeze

    def self.connect_to_database
      require 'active_record'
      ActiveRecord::Base.configurations = Ralph.database_configs
      ActiveRecord::Base.establish_connection(Ralph.current_database_config)
    end

    def self.initialize_bot
      $LOAD_PATH.unshift(Ralph.root.join('lib'))
      require 'ralph'

      api_key = ENV['ZULIP_API_KEY']
      email = ENV['ZULIP_EMAIL']
      host = ENV['ZULIP_HOST']
      name = ENV['BOT_NAME']

      Ralph.bot = Ralph::Bot.new(api_key: api_key, email: email, host: host, name: name)
      Ralph.bot.logger = Ralph.logger
    end

    def self.load_environment
      configure_root
      configure_logger
      load_bundler_dependencies
      configure_autoloader
      load_environment_config
    end

    def self.load_initializers
      initializers_pattern = Ralph.root.join('config/initializers/*.rb')
      Dir[initializers_pattern].sort.each { |file| require(file) }
    end

    private

    def self.configure_autoloader
      require 'zeitwerk'
      loader = Zeitwerk::Loader.new

      AUTOLOAD_PATHS.each do |path|
        loader.push_dir(Ralph.root.join(path))
      end

      loader.setup
    end
    private_class_method :configure_autoloader

    def self.configure_logger
      require 'logger'
      Ralph.logger = Logger.new(STDOUT)
    end
    private_class_method :configure_logger

    def self.configure_root
      require 'pathname'
      Ralph.root = Pathname.new(File.expand_path(File.join(__dir__, '..')))
    end
    private_class_method :configure_root

    def self.ensure_required_environment_variables!
      return if REQUIRED_ENVIRONMENT_VARIABLES.all? { |key| ENV.key?(key) }

      warn "Please set #{REQUIRED_ENVIRONMENT_VARIABLES.join(', ')}"
      exit 1
    end
    private_class_method :ensure_required_environment_variables!

    def self.environment_config_path
      Ralph.root.join('config/environments', Ralph.env)
    end
    private_class_method :environment_config_path

    def self.load_bundler_dependencies
      require 'bundler/setup'
      require 'active_support/all'
    end
    private_class_method :load_bundler_dependencies

    def self.load_environment_config
      Ralph.env = ActiveSupport::StringInquirer.new(ENV.fetch('RALPH_ENV', 'development'))
      require environment_config_path
      ensure_required_environment_variables!
    end
    private_class_method :load_environment_config
  end
end
