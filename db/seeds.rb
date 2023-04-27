#
# Place all seeds in /seeds/ folder.
#

Spree::Webhooks.disable_webhooks do
  Dir[File.dirname(__FILE__) + '/seeds/*.rb'].sort.each do |file|
    Rails.logger.info "Seeds #{file} ..."
    require file
  end
end

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
