describe Ralph::Bot do
  let(:bot) do
    described_class.new(api_key: 'test-api-key', email: 'test@example.com',
      host: 'test.example.com')
  end

  before do
    # Silence noisy log output during the test run
    @old_logger_level = bot.logger.level
    bot.logger.error!
  end

  after do
    bot.logger.level = @old_logger_level
  end

  describe '#client' do
    subject { bot.client }

    context 'with the default client' do
      it 'returns a properly-configured client' do
        expect(subject.api_key).to eq('test-api-key')
        expect(subject.email).to eq('test@example.com')
        expect(subject.host).to eq('test.example.com')
      end
    end

    context 'with a custom client' do
      let(:bot) { described_class.new(client: custom_client) }
      let(:custom_client) { double('client') }
      it { is_expected.to eq(custom_client) }
    end
  end

  describe '#install_plugin' do
    let(:plugin) { double('plugin') }
    before { bot.install_plugin(plugin) }

    it 'installs the plugin' do
      expect(bot.plugins).to include(plugin)
    end
  end

  describe '#logger' do
    subject { bot.logger }

    let(:logger_double) { double('logger') }

    before do
      @old_logger = bot.logger
      bot.logger = logger_double
    end

    after { bot.logger = @old_logger }

    it { is_expected.to eq(logger_double) }
  end

  describe '#logger=' do
    let(:logger_double) { double('logger') }

    before do
      @old_logger = bot.logger
      bot.logger = logger_double
    end

    after { bot.logger = @old_logger }

    it 'sets the logger' do
      expect(bot.logger).to eq(logger_double)
    end
  end

  describe '#plugins' do
    subject { bot.plugins }

    context 'before installing any plugins' do
      it { is_expected.to be_empty }
    end

    context 'after installing a plugin' do
      let(:plugin) { double('plugin') }
      before { bot.install_plugin(plugin) }
      it { is_expected.to match_array([plugin]) }
    end
  end

  describe '#run' do
    let(:bot) { described_class.new(client: client) }
    let(:client) { QueuedClient.new }

    context 'when the server emits a heartbeat event' do
      before do
        boring_plugin = double('boring plugin')
        @heartbeat_plugin = double('heartbeat plugin', on_heartbeat: true)

        bot.install_plugin(boring_plugin)
        bot.install_plugin(@heartbeat_plugin)

        heartbeat_event = WonderLlama::HeartbeatEvent.new(client: bot.client, params: { 'id' => 1 })
        client.queue_event(heartbeat_event)

        bot.run
      end

      it 'distributes the event to plugins that respond to #on_heartbeat' do
        expect(@heartbeat_plugin).to have_received(:on_heartbeat).once
      end
    end

    context 'when the server emits a message event' do
      before do
        boring_plugin = double('boring plugin')
        @message_plugin = double('message plugin', on_message: true)

        bot.install_plugin(boring_plugin)
        bot.install_plugin(@message_plugin)

        @message = double('message')
        message_event = WonderLlama::MessageEvent.new(client: bot.client,
          params: { 'id' => 1 })
        allow(message_event).to receive(:message).and_return(@message)
        client.queue_event(message_event)

        bot.run
      end

      it 'distributes the event to plugins that respond to #on_message' do
        expect(@message_plugin).to have_received(:on_message).with(@message).once
      end
    end

    context 'when the server emits an unknown event' do
      before do
        boring_plugin = double('boring plugin')
        @unknown_plugin = double('unknown plugin', on_unknown: true)

        bot.install_plugin(boring_plugin)
        bot.install_plugin(@unknown_plugin)

        @unknown_event = WonderLlama::Event.new(client: bot.client,
          params: { 'id' => 1, 'type' => 'unknown' })
        client.queue_event(@unknown_event)

        bot.run
      end

      it 'distributes the event to plugins that respond to #on_unknown' do
        expect(@unknown_plugin).to have_received(:on_unknown).with(@unknown_event).once
      end
    end
  end
end
