describe PingPlugin do
  subject { ralph }

  let(:server) { IntegrationTestServer.new }
  let(:ralph) { server.create_bot_session('Ralph') }
  let(:human) { server.create_session('Human') }

  before do
    ping_plugin = described_class.new
    ralph.install_plugin(ping_plugin)
  end

  describe 'pinging the bot' do
    shared_examples 'responds with pong' do
      it { is_expected.to have_sent_message('pong!').to_stream('pings').in_topic('shenanigans') }
    end

    context 'when someone addresses the bot with a ping' do
      before { human.send_message('ralph ping', stream: 'pings', topic: 'shenanigans') }
      include_examples 'responds with pong'
    end

    context 'when someone addresses the bot with a weirdly-cased ping' do
      before { human.send_message('rAlPh PiNg', stream: 'pings', topic: 'shenanigans') }
      include_examples 'responds with pong'
    end

    context 'when someone addresses the bot with an unrelated message' do
      before { human.send_message('ralph unrelated', stream: 'pings', topic: 'shenanigans') }
      it { is_expected.to_not have_sent_message }
    end

    context 'when the message is not a ping' do
      before { human.send_message('unrelated', stream: 'pings', topic: 'shenanigans') }
      it { is_expected.to_not have_sent_message }
    end
  end
end
