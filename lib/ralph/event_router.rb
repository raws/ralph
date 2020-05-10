module Ralph
  class EventRouter
    def initialize(plugin, event)
      @plugin = plugin
      @event = event
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

    def deliver_heartbeat_event
      @plugin.on_heartbeat if @plugin.respond_to?(:on_heartbeat)
    end

    def deliver_message_event
      @plugin.on_message(@event.message) if @plugin.respond_to?(:on_message)
    end

    def deliver_unknown_event
      @plugin.on_unknown(@event) if @plugin.respond_to?(:on_unknown)
    end
  end
end
