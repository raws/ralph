begin
  require 'dotenv/load'
rescue LoadError
  # no-op
end

required_environment_variables = %w[BOT_NAME ZULIP_API_KEY ZULIP_EMAIL ZULIP_HOST]

unless required_environment_variables.all? { |key| ENV.key?(key) }
  warn "Please set #{required_environment_variables.join(', ')}"
  exit 1
end
