module Ralph
  class Bot
    attr_accessor :logger
    attr_reader :client, :plugins

    def initialize(api_key: nil, client: nil, email: nil, host: nil)
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
        distribute_event_to_plugins(event)
      end
    end

    private

    def distribute_event_to_plugins(event)
      plugins.each do |plugin|
        case event
        when WonderLlama::HeartbeatEvent
          distribute_heartbeat_event_to_plugin(plugin)
        when WonderLlama::MessageEvent
          distribute_message_event_to_plugin(plugin, event)
        else
          distribute_unknown_event_to_plugin(plugin, event)
        end
      end
    end

    def distribute_heartbeat_event_to_plugin(plugin)
      if plugin.respond_to?(:on_heartbeat)
        plugin.on_heartbeat
      end
    end

    def distribute_message_event_to_plugin(plugin, message_event)
      if plugin.respond_to?(:on_message)
        plugin.on_message(message: message_event.message)
      end
    end

    def distribute_unknown_event_to_plugin(plugin, unknown_event)
      if plugin.respond_to?(:on_unknown)
        plugin.on_unknown(event: unknown_event)
      end
    end
  end
end
