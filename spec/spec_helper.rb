require_relative '../lib/ralph'
require_relative '../config/boot'
Ralph::Boot.load_environment
Ralph::Boot.connect_to_database

require 'database_cleaner/active_record'
require 'factory_bot'

support_files_pattern = File.join(__dir__, 'support/**/*.rb')
Dir[support_files_pattern].sort.each { |file| require(file) }

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
  config.include(HaveSentMessageMatcher)
  config.include(MessageWithContentExpectation)

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    FactoryBot.find_definitions
  end
end
