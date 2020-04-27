class QueuedClient
  def initialize
    @queued_events = []
  end

  def api_key
    'test-api-key'
  end

  def email
    'test@example.com'
  end

  def host
    'test.example.com'
  end

  def queue_event(event)
    @queued_events << event
  end

  def stream_events(&block)
    @queued_events.each(&block)
  end
end
