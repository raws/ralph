class IntegrationTestClient
  def initialize(server:, session:)
    @server = server
    @session = session
  end

  def send_message(content:, to:, topic: nil)
    event_params = message_event_params(content: content, to: to, topic: topic)
    message_event = WonderLlama::MessageEvent.new(client: self, params: event_params)
    @server.broadcast_event(from: @session, event: message_event)
  end

  private

  # rubocop:disable Metrics/MethodLength
  def message_event_params(content:, to:, topic: nil)
    message_type = topic ? WonderLlama::Message::STREAM_TYPE : WonderLlama::Message::PRIVATE_TYPE

    {
      'id' => @server.next_event_id,
      'message' => {
        'id' => @server.next_message_id,
        'content' => content,
        'to' => to,
        'topic' => topic,
        'type' => message_type
      },
      'type' => 'message'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
