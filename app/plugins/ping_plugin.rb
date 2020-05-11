class PingPlugin
  def on_addressed(message)
    @message = message
    pong! if ping?
  end

  private

  def ping?
    @message.content.downcase.start_with?('ping')
  end

  def pong!
    @message.reply('pong!')
  end
end
