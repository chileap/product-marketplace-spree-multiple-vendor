module Spree::UserDecorator
  def self.prepended(base)
    base.extend FriendlyId
    base.friendly_id :first_name, use: %i[slugged history]

    base.has_one :profile_picture, as: :viewable, dependent: :destroy, class_name: 'Spree::Image'
    base.has_many :favorite_vendors, class_name: 'Spree::FavoriteVendor', dependent: :destroy
    base.has_many :bookmark_vendors, through: :favorite_vendors, class_name: 'Spree::Vendor'

    base.validates :first_name, presence: true
    base.validates_associated :profile_picture
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def should_generate_new_friendly_id?
    slug.blank? || first_name_changed?
  end
end

Spree.user_class.prepend Spree::UserDecorator
