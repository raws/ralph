module HaveSentMessageMatcher
  def have_sent_message(expected_content = nil)
    HaveSentMessage.new(expected_content)
  end

  class HaveSentMessage
    def initialize(expected_content = nil)
      @expected_content = expected_content
    end

    def description
      "have sent #{formatted_expectation}"
    end

    def diffable?
      false
    end

    def failure_message
      <<~MESSAGE
        expected #{@session} to send #{formatted_expectation}
        messages sent by #{@session}:
        #{formatted_actual_messages}
      MESSAGE
    end

    def failure_message_when_negated
      <<~MESSAGE
        expected #{@session} to not send #{formatted_expectation}
        messages sent by #{@session}:
        #{formatted_actual_messages}
      MESSAGE
    end

    def in_topic(expected_topic)
      @expected_topic = expected_topic
      self
    end

    def matches?(session)
      @session = session
      any_matching_messages_sent_by_session?
    end

    def supports_block_expectations?
      false
    end

    def to_stream(expected_stream)
      @expected_stream = expected_stream
      self
    end

    private

    def actual_messages
      @session.sent_message_events.map(&:message)
    end

    def any_matching_messages_sent_by_session?
      actual_messages.any? do |message|
        message_matches?(message)
      end
    end

    def content_matches?(message)
      if @expected_content
        message.content == @expected_content
      else
        true
      end
    end

    def formatted_actual_messages
      actual_messages.map do |message|
        "  - #{message.content.inspect} in #{message.to} > #{message.topic}"
      end.join("\n")
    end

    def formatted_expectation
      "#{formatted_expected_content} in #{formatted_expected_stream} > #{formatted_expected_topic}"
    end

    def formatted_expected_content
      if @expected_content
        @expected_content.inspect
      else
        'any message'
      end
    end

    def formatted_expected_stream
      @expected_stream || 'any stream'
    end

    def formatted_expected_topic
      @expected_topic || 'any topic'
    end

    def message_matches?(message)
      content_matches?(message) && stream_matches?(message) && topic_matches?(message)
    end

    def stream_matches?(message)
      if @expected_stream
        message.to == @expected_stream
      else
        true
      end
    end

    def topic_matches?(message)
      if @expected_topic
        message.topic == @expected_topic
      else
        true
      end
    end
  end
end
