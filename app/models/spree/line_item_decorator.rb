module Spree::LineItemDecorator
  def self.prepended(base)
    base.belongs_to :vendor, class_name: 'Spree::Vendor', optional: true
  end
end

Spree::LineItem.prepend Spree::LineItemDecorator
