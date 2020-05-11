module Ralph
  class EventRouter
    def initialize(plugin, event, bot_name:)
      @plugin = plugin
      @event = event
      @bot_name = bot_name
    end

    def deliver
      if @event.heartbeat?
        deliver_heartbeat_event
      elsif @event.message?
        deliver_message_event
      else
        deliver_unknown_event
      end
    end

    private

    def deliver_addressed_message
      return unless @plugin.respond_to?(:on_addressed)

      addressed_message = AddressedMessage.new(@event.message, bot_name: @bot_name)
      @plugin.on_addressed(addressed_message)
    end

    def deliver_heartbeat_event
      @plugin.on_heartbeat if @plugin.respond_to?(:on_heartbeat)
    end

    def deliver_message_event
      if message_addressed_to_bot?
        deliver_addressed_message
      elsif @plugin.respond_to?(:on_message)
        @plugin.on_message(@event.message)
      end
    end

    def deliver_unknown_event
      @plugin.on_unknown(@event) if @plugin.respond_to?(:on_unknown)
    end

    def message_addressed_to_bot?
      AddressedMessage.addressed_to_bot?(@event.message.content, bot_name: @bot_name)
    end
  end
end
