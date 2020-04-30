class PingPlugin
  def receive_event(event)
    pong!(event) if ping?(event)
  end

  private

  def ping?(event)
    event.message? && event.message.content.downcase.start_with?('ralph ping')
  end

  def pong!(event)
    event.message.reply('pong!')
  end
end
