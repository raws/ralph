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
    @plugins.each { |plugin| plugin.receive_event(event) }
  end
end
