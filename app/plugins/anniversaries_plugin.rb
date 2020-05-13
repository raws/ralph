class AnniversariesPlugin
  LOOKING_UP_ANNIVERSARIES_PATTERN = //i.freeze
  SETTING_BIRTHDAY_PATTERN = /\A(?<name>.*) was born on (?<birthday>.*)\z/i.freeze
  SETTING_START_DATE_PATTERN = //i.freeze

  def on_addressed(message)
    @message = message

    if setting_birthday?
      set_birthday
    elsif setting_start_date?
      set_start_date
    elsif looking_up_anniversaries?
      look_up_anniversaries
    end
  end

  private

  def format_anniversary(date)
    date.strftime('%B %-d')
  end

  def look_up_anniversaries
    # TODO
  end

  def looking_up_anniversaries?
    @message.content.match?(LOOKING_UP_ANNIVERSARIES_PATTERN)
  end

  def set_birthday
    match_data = @message.content.match(SETTING_BIRTHDAY_PATTERN)
    name = match_data[:name]
    birthday = Date.parse(match_data[:birthday])

    user = User.where('name ILIKE ?', "#{name}%").first

    if user
      user.update(born_on: birthday)
      @message.reply("Okay, #{user.name}'s birthday is #{format_anniversary(birthday)}!")
    else
      @message.reply("Sorry, I don't know anyone named #{name}!")
    end
  rescue Date::Error
    @message.reply("Sorry, I don't recognize “#{match_data[:birthday]}” as a date!")
  end

  def set_start_date
    # TODO
  end

  def setting_birthday?
    @message.content.match?(SETTING_BIRTHDAY_PATTERN)
  end

  def setting_start_date?
    @message.content.match?(SETTING_START_DATE_PATTERN)
  end
end
