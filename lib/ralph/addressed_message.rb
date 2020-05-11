module Ralph
  class AddressedMessage < Delegator
    def initialize(message, bot_name:)
      @message = message
      @bot_name = bot_name
    end

    def self.addressed_to_bot?(message, bot_name:)
      message.match?(bot_name_pattern(bot_name))
    end

    def self.bot_name_pattern(bot_name)
      /\A\s*#{Regexp.escape(bot_name)}(?:\z|\s+|:\s*)/i
    end

    def __getobj__
      @message
    end

    def content
      @content ||= content_without_bot_name
    end

    private

    def content_without_bot_name
      bot_name_pattern = self.class.bot_name_pattern(@bot_name)
      __getobj__.content.sub(bot_name_pattern, '')
    end
  end
end
