module Spree::UserDecorator
  def self.prepended(base)
    base.extend FriendlyId
    base.friendly_id :first_name, use: %i[slugged history]

    base.has_one :profile_picture, as: :viewable, dependent: :destroy, class_name: 'Spree::Image'
    base.validates :first_name, presence: true

    private

    def should_generate_new_friendly_id?
      slug.blank? || first_name_changed?
    end
  end
end

Spree.user_class.prepend Spree::UserDecorator
