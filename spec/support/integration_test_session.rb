class IntegrationTestSession
  attr_reader :client, :name

  def initialize(name:, server:)
    @name = name
    @server = server
    @client = IntegrationTestClient.new(server: server, session: self)
  end

  def inspect
    "#<#{self.class.name} #{name.inspect}>"
  end

  def receive_event(event)
    # no-op
  end

  def send_message(message, stream:, topic:)
    @client.send_message(content: message, to: stream, topic: topic)
  end

  def sent_events
    @server.events_from(self)
  end

  def sent_message_events
    sent_events.select { |event| event.is_a?(WonderLlama::MessageEvent) }
  end

  def to_s
    inspect
  end
end
