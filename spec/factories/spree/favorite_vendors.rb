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
FactoryBot.define do
  factory :favorite_vendor, class: Spree::FavoriteVendor do
    association :vendor, factory: :vendor
    association :user, factory: :user
  end
end
