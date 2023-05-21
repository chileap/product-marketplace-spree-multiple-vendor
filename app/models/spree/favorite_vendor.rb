# == Schema Information
#
# Table name: spree_favorite_vendors
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  vendor_id  :bigint           not null
#
# Indexes
#
#  index_spree_favorite_vendors_on_user_id                (user_id)
#  index_spree_favorite_vendors_on_user_id_and_vendor_id  (user_id,vendor_id) UNIQUE
#  index_spree_favorite_vendors_on_vendor_id              (vendor_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => spree_users.id)
#  fk_rails_...  (vendor_id => spree_vendors.id)
#
module Spree
  class FavoriteVendor < Spree::Base
    belongs_to :vendor, class_name: 'Spree::Vendor', inverse_of: :favorite_vendors
    belongs_to :user, class_name: 'Spree::User', inverse_of: :favorite_vendors

    validates :vendor_id, uniqueness: { scope: :user_id }

    def self.favorites_for_user(user)
      where(user_id: user.id).includes(:vendor).map(&:vendor)
    end

    def self.favorite?(vendor, user)
      where(vendor_id: vendor.id, user_id: user.id).exists?
    end

    def self.favorite(vendor, user)
      create(vendor_id: vendor.id, user_id: user.id)
    end

    def self.unfavorite(vendor, user)
      where(vendor_id: vendor.id, user_id: user.id).destroy_all
    end

    def self.toggle_favorite(vendor, user)
      if favorite?(vendor, user)
        unfavorite(vendor, user)
      else
        favorite(vendor, user)
      end
    end

    def self.favorites_count(vendor)
      where(vendor_id: vendor.id).count
    end

    def self.favorites_count_for_user(user)
      where(user_id: user.id).count
    end

    def self.favorites_count_for_vendor(vendor)
      where(vendor_id: vendor.id).count
    end
  end
end
