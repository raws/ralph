module Ralph
  class Bot
    attr_accessor :logger
    attr_reader :client, :name, :plugins

    def initialize(api_key: nil, client: nil, email: nil, host: nil, name:)
      @name = name
      @client = client || WonderLlama::Client.new(api_key: api_key, email: email, host: host)
      @logger = Logger.new(STDOUT)
      @plugins = []
    end

    def install_plugin(plugin)
      plugins << plugin
      logger.info("Installed #{plugin}")
    end

    def run
      logger.info("Connecting to #{client.host} as #{client.email}...")

      client.stream_events do |event|
        logger.debug("Received event: #{event.inspect}")
        distribute_event_to_plugins(event)
      end
    end

    private

    def distribute_event_to_plugins(event)
      plugins.each do |plugin|
        EventRouter.new(plugin, event, bot_name: name).deliver
      end
    end
  end
end
