# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment.rb', __FILE__)

require 'shoulda/matchers'
require 'factory_bot_rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }

ActiveJob::Base.queue_adapter = :inline

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
