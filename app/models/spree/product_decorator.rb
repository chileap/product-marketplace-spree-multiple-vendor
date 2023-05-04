module Spree::ProductDecorator
  def self.prepended(base)
    base.belongs_to :vendor, class_name: 'Spree::Vendor'
  end
end

Spree::Product.prepend Spree::ProductDecorator
