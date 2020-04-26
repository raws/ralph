class TestClient
  def initialize
    @queued_events = []
  end

  def api_key
    'test-api-key'
  end

  def email
    'test@example.com'
  end

  def get_events_from_event_queue(*args)
    raise NotImplementedError
  end

  def host
    'test.example.com'
  end

  def queue_event(event)
    @queued_events << event
  end

  def register_event_queue
    raise NotImplementedError
  end

  def send_message(*args)
    raise NotImplementedError
  end

  def stream_events(&block)
    @queued_events.each(&block)
  end
end
