class PingPlugin
  def on_message(message)
    @message = message
    pong! if ping?
  end

  private

  def ping?
    @message.content.downcase.start_with?('ralph ping')
  end

  def pong!
    @message.reply('pong!')
  end
end
