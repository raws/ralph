require_relative 'integration_test_session'

class IntegrationTestBot < IntegrationTestSession
  def initialize(**)
    super
    @plugins = []
  end

  def install_plugin(plugin)
    @plugins << plugin
  end

  def receive_event(event)
    @plugins.each do |plugin|
      Ralph::EventRouter.new(plugin, event, bot_name: name).deliver
    end
  end
end
