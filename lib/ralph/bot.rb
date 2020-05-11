module Ralph
  class Bot
    attr_reader :client, :name, :plugins
    attr_writer :logger

    def initialize(api_key: nil, client: nil, email: nil, host: nil, name:)
      @name = name
      @client = client || WonderLlama::Client.new(api_key: api_key, email: email, host: host)
      @plugins = []
    end

    def install_plugin(plugin)
      plugins << plugin
      logger.info("Installed #{plugin}")
    end

    def logger
      @logger ||= Logger.new(STDOUT)
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
