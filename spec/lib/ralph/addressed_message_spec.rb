describe Ralph::AddressedMessage do
  describe 'delegation' do
    before { @wrapped_message = double('message', other_message: true) }

    it 'delegates unrecognized methods to the message it wraps' do
      described_class.new(@wrapped_message, bot_name: 'Ralph').other_message
      expect(@wrapped_message).to have_received(:other_message).once
    end
  end

  describe '.addressed_to_bot?' do
    context 'when the message is addressed to the bot' do
      context 'with just the bot name' do
        subject { described_class.addressed_to_bot?('ralph', bot_name: 'Ralph') }
        it { is_expected.to eq(true) }
      end

      context 'with differing bot name case' do
        subject { described_class.addressed_to_bot?('rAlPh foo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(true) }
      end

      context 'with leading whitespace' do
        subject { described_class.addressed_to_bot?('  ralph foo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(true) }
      end

      context 'with a colon after the bot name' do
        subject { described_class.addressed_to_bot?('ralph: foo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(true) }
      end

      context 'without whitespace after the colon' do
        subject { described_class.addressed_to_bot?('ralph:foo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(true) }
      end

      context 'without anything after the colon' do
        subject { described_class.addressed_to_bot?('ralph:', bot_name: 'Ralph') }
        it { is_expected.to eq(true) }
      end
    end

    context 'when the message is not addressed to the bot' do
      context 'with a different bot name' do
        subject { described_class.addressed_to_bot?('ari foo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(false) }
      end

      context 'without whitespace after the bot name' do
        subject { described_class.addressed_to_bot?('ralphfoo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(false) }
      end

      context 'with a colon and a different bot name' do
        subject { described_class.addressed_to_bot?('ari: foo bar', bot_name: 'Ralph') }
        it { is_expected.to eq(false) }
      end
    end
  end

  describe '#content' do
    subject { described_class.new(@wrapped_message, bot_name: 'Ralph').content }

    before do
      @wrapped_message = instance_double('WonderLlama::Message',
        content: ' rAlPh:   hello there, Ralph')
    end

    it 'returns the content without the leading bot name and whitespace' do
      expect(subject).to eq('hello there, Ralph')
    end
  end
end
