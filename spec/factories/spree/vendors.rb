# == Schema Information
#
# Table name: spree_vendors
#
#  id                 :integer          not null, primary key
#  about_us           :text
#  address1           :string
#  address2           :string
#  city               :string
#  commission_rate    :float            default(5.0)
#  contact_us         :text
#  deleted_at         :datetime
#  name               :string
#  notification_email :string
#  phone              :string
#  priority           :integer
#  shop_currency      :string           default("USD")
#  shop_locale        :string           default("en")
#  slug               :string
#  state_name         :string
#  status             :string
#  zipcode            :string
#  created_at         :datetime
#  updated_at         :datetime
#  bill_address_id    :bigint
#  country_id         :integer
#  ship_address_id    :bigint
#  state_id           :integer
#
# Indexes
#
#  index_spree_vendors_on_bill_address_id  (bill_address_id)
#  index_spree_vendors_on_deleted_at       (deleted_at)
#  index_spree_vendors_on_name             (name) UNIQUE
#  index_spree_vendors_on_ship_address_id  (ship_address_id)
#  index_spree_vendors_on_shop_currency    (shop_currency)
#  index_spree_vendors_on_shop_locale      (shop_locale)
#  index_spree_vendors_on_slug             (slug) UNIQUE
#  index_spree_vendors_on_status           (status)
#
# Foreign Keys
#
#  fk_rails_...  (bill_address_id => spree_addresses.id)
#  fk_rails_...  (ship_address_id => spree_addresses.id)
#
FactoryBot.define do
  factory :vendor, class: Spree::Vendor do
    name { Faker::Company.name }
    about_us { 'About us...' }
    contact_us { 'Contact us...' }

    factory :active_vendor do
      name { 'Active vendor' }
      state { :active }
    end

    factory :active_vendor_list do
      name { "#{Faker::Company.name} #{Faker::Company.suffix}" }
      state { :active }
    end

    factory :pending_vendor do
      name { 'Pending vendor' }
      state { :pending }
    end

    factory :blocked_vendor do
      name { 'Blocked vendor' }
      state { :blocked }
    end
  end
end
