# Load the Rails application.
require_relative 'application'

# Load mailer ENV variables
app_env_vars = File.join(Rails.root, 'config', 'initializers', 'app_env_vars.rb')
if File.exists? app_env_vars
  load(app_env_vars)
end

# Initialize the Rails application.
Rails.application.initialize!
