require File.expand_path('../../../lib/spree_frontend', __FILE__)

Rails.application.config.after_initialize do
  Spree::Backend::Config[:admin_show_version] = false
  Spree.config do |config|
    config.track_inventory_levels = true
  end
end

Spree::Frontend::Config = Spree::Frontend::Configuration.new
Spree.user_class = 'Spree::User'
