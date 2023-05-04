module Spree::VendorDecorator
  def self.prepended(base)
    base.has_many :line_items, class_name: 'Spree::LineItem', foreign_key: :vendor_id, dependent: :nullify
    base.has_many :orders, class_name: 'Spree::Order', through: :line_items, dependent: :nullify
  end
end

Spree::Vendor.prepend Spree::VendorDecorator
