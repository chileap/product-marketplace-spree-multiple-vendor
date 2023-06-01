require File.expand_path('../../../lib/spree_frontend', __FILE__)

require './lib/spree/core/search/base'

Rails.application.config.after_initialize do
  Spree::Backend::Config[:admin_show_version] = false
  Spree.config do |config|
    config.track_inventory_levels = true
  end

  SpreeMultiVendor::Config[:vendorized_models] = %w[product variant stock_location shipping_method line_item]
  Spree::Frontend::Config = Spree::Frontend::Configuration.new
  Spree.user_class = 'Spree::User'
end
