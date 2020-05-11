describe Ralph::EventRouter do
  shared_examples 'when the plugin does not listen for the event' do |callback|
    context "when the plugin does not respond to ##{callback}" do
      let(:plugin) { double('boring plugin') }

      it "does not call ##{callback}" do
        expect { subject }.to_not raise_error
      end
    end
  end

  describe '#deliver' do
    subject! { described_class.new(plugin, event, bot_name: 'Ralph').deliver }

    context 'with a heartbeat event' do
      let(:event) { heartbeat_event }

      context 'when the plugin responds to #on_heartbeat' do
        let(:plugin) { double('heartbeat plugin', on_heartbeat: true) }

        it 'calls #on_heartbeat' do
          expect(plugin).to have_received(:on_heartbeat).once
        end
      end

      include_examples 'when the plugin does not listen for the event', :on_heartbeat
    end

    context 'with a message event' do
      let(:event) { message_event(message) }

      context 'when the message is addressed to the bot' do
        let(:message) { double('message', content: 'ralph: foo bar') }

        context 'when the plugin responds to #on_addressed' do
          let(:plugin) { double('addressed plugin', on_addressed: true) }

          it 'calls #on_addressed with a message stripped of the bot name' do
            expect(plugin).to have_received(:on_addressed).with(message_with_content('foo bar'))
          end
        end

        include_examples 'when the plugin does not listen for the event', :on_addressed
      end

      context 'when the message is not addressed to the bot' do
        let(:message) { double('message', content: 'foo bar') }

        context 'when the plugin responds to #on_message' do
          let(:plugin) { double('message plugin', on_message: true) }

          it 'calls #on_message with the message' do
            expect(plugin).to have_received(:on_message).with(message).once
          end
        end

        include_examples 'when the plugin does not listen for the event', :on_message
      end
    end

    context 'with an unknown event' do
      let(:event) { unknown_event }

      context 'when the plugin responds to #on_unknown' do
        let(:plugin) { double('curious plugin', on_unknown: true) }

        it 'calls #on_unknown with the event' do
          expect(plugin).to have_received(:on_unknown).with(event).once
        end
      end

      include_examples 'when the plugin does not listen for the event', :on_unknown
    end
  end

  private

  def client_double
    double('client')
  end

  def heartbeat_event
    WonderLlama::HeartbeatEvent.new(client: client_double, params: {})
  end

  def message_event(message_double)
    WonderLlama::MessageEvent.new(client: client_double, params: {}).tap do |event|
      allow(event).to receive(:message).and_return(message_double)
    end
  end

  def unknown_event
    WonderLlama::Event.new(client: client_double, params: {})
  end
end
