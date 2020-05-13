describe AnniversariesPlugin do
  subject { ralph }

  let(:server) { IntegrationTestServer.new }
  let(:ralph) { server.create_bot_session('Ralph') }
  let(:ari) { server.create_session('Ari') }
  let(:ian) { server.create_session('Ian') }

  before do
    anniversaries_plugin = described_class.new
    ralph.install_plugin(anniversaries_plugin)
  end

  describe 'setting a birthday' do
    context 'when the name matches a Zulip user' do
      context 'and Ralph already knows about them' do
        before do
          ari.create_user!
          ian.send_message('ralph ari was born on 4/20', stream: 'birthdays', topic: 'ari')
        end

        it 'saves the user\'s birthday' do
          expected_birthday = Date.current.change(month: 4, day: 20)
          expect(ari.user.born_on).to eq(expected_birthday)
        end

        it 'responds with a confirmation' do
          expect(subject).to have_sent_message('Okay, Ari\'s birthday is April 20!').
            to_stream('birthdays').in_topic('ari')
        end
      end

      context 'and Ralph does not know about them'
    end

    context 'when the name does not match a Zulip user'

    context 'when the birthday is invalid'

    context 'when the user update fails'
  end
end
