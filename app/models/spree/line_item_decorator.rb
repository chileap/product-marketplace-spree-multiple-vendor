module Spree::LineItemDecorator
  def self.prepended(base)
    base.belongs_to :vendor, class_name: 'Spree::Vendor', optional: true
    base.before_validation :set_vendor
    base.scope :by_vendor, ->(vendor_id) { where(vendor_id: vendor_id) }

    def set_vendor
      self.vendor_id = product.vendor_id
    end
  end
end

Spree::LineItem.prepend Spree::LineItemDecorator
