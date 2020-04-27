require_relative '../lib/ralph'

app_files_pattern = File.join(__dir__, '../app/**/*.rb')
Dir[app_files_pattern].sort.each { |file| require(file) }

support_files_pattern = File.join(__dir__, 'support/**/*.rb')
Dir[support_files_pattern].sort.each { |file| require(file) }

RSpec.configure do |config|
  config.include(HaveSentMessageMatcher)
end
