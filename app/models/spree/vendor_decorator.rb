module Spree::VendorDecorator
  def self.prepended(base)
    base.has_many :orders, class_name: 'Spree::Order', through: :line_items
  end
end

Spree::Vendor.prepend Spree::VendorDecorator