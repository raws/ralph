class TestMessage
  attr_reader :from, :message, :stream, :topic

  def initialize(from:, message:, stream:, topic:)
    @from = from
    @message = message
    @stream = stream
    @topic = topic
  end
end
