module Spree::ProductDecorator
  attr_accessor :quantity

  def self.prepended(base)
    base.belongs_to :vendor, class_name: 'Spree::Vendor'
  end

  def quantity
    return 0 if master.stock_items.first.nil?

    master.stock_items.first.count_on_hand
  end
end

Spree::Product.prepend Spree::ProductDecorator
