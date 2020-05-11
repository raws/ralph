module MessageWithContentExpectation
  def message_with_content(expected_content)
    MessageWithContent.new(expected_content)
  end

  class MessageWithContent
    def initialize(expected_content)
      @expected_content = expected_content
    end

    def ===(actual)
      actual.content == @expected_content
    end

    def inspect
      "<message with content #{@expected_content.inspect}>"
    end
  end
end
