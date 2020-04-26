require_relative '../lib/ralph'

support_files_pattern = File.join(File.dirname(__FILE__), 'support/**/*.rb')
Dir[support_files_pattern].each { |file| require(file) }
