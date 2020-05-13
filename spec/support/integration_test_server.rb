class IntegrationTestServer
  attr_reader :events, :sessions

  def initialize
    @events = []
    @sessions = []

    @last_event_id = 0
    @last_message_id = 0
    @last_session_id = 0
  end

  def broadcast_event(from:, event:)
    @events << [from, event]

    @sessions.each do |session|
      next if session == from

      event_for_session = clone_event_for_session(event, session)
      session.receive_event(event_for_session)
    end
  end

  def create_bot_session(name)
    IntegrationTestBot.new(name: name, server: self).tap do |session|
      @sessions << session
    end
  end

  def create_session(name)
    IntegrationTestSession.new(name: name, server: self).tap do |session|
      @sessions << session
    end
  end

  def events_from(session)
    @events.filter_map { |from, event| from == session && event }
  end

  def find_session(name)
    sessions.find { |session| session.name == name }
  end

  def next_event_id
    @last_event_id += 1
  end

  def next_message_id
    @last_message_id += 1
  end

  def next_session_id
    @last_session_id += 1
  end

  private

  def clone_event_for_session(event, session)
    event.class.new(client: session.client, params: event.params.dup)
  end
end
