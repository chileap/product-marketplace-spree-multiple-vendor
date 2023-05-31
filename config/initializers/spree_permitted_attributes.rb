module Spree
  module PermittedAttributes
    ATTRIBUTES << :vendor_attributes

    mattr_reader *ATTRIBUTES

    @@vendor_attributes = [:name, :about_us, :contact_us, :notification_email]
    @@vendor_attributes << :image
    @@vendor_attributes << :cover_image
  end
end
