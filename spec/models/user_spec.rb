describe User do
  describe '.born_today' do
    subject { described_class.born_today }

    before do
      today_but_different_year = Date.current.advance(years: -1)
      @user_born_today = create(:user, born_on: today_but_different_year)
      _user_not_born_today = create(:user, born_on: Date.yesterday)
    end

    it 'returns users born on the current day in any year' do
      expect(subject).to match_array([@user_born_today])
    end
  end
end
