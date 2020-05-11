module Ralph
  class << self
    attr_accessor :bot
  end

  def self.boot!
    Boot.load_bundler_dependencies
    Boot.load_ralph_lib
    Boot.load_environment
    Boot.load_bot
    Boot.configure_app_load_path
    Boot.load_initializers
  end

  def self.install_plugin(plugin)
    bot.install_plugin(plugin)
  end

  def self.run!
    bot.run
  end

  module Boot
    def self.configure_app_load_path
      $LOAD_PATH.unshift(File.join(__dir__, '../app/plugins'))
    end

    def self.load_bot
      api_key = ENV['ZULIP_API_KEY']
      email = ENV['ZULIP_EMAIL']
      host = ENV['ZULIP_HOST']
      name = ENV['BOT_NAME']

      Ralph.bot = Ralph::Bot.new(api_key: api_key, email: email, host: host, name: name)
    end

    def self.load_bundler_dependencies
      require 'bundler/setup'
    end

    def self.load_environment
      require_relative 'environment'
    end

    def self.load_initializers
      initializers_pattern = File.join(__dir__, 'initializers/*.rb')
      Dir[initializers_pattern].sort.each { |file| require(file) }
    end

    def self.load_ralph_lib
      $LOAD_PATH.unshift(File.join(__dir__, '../lib'))
      require 'ralph'
    end
  end
end

Ralph.boot!
