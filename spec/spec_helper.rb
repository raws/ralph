require_relative '../lib/ralph'

support_files_pattern = File.join(__dir__, 'support/**/*.rb')
Dir[support_files_pattern].sort.each { |file| require(file) }

RSpec.configure do |config|
  config.include(HaveSentMessageMatcher)
  config.include(MessageWithContentExpectation)
end

require_relative '../config/boot'
Ralph::Boot.load_environment
Ralph::Boot.connect_to_database
