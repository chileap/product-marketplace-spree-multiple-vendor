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
module Spree
  class Vendor < Spree::Base
    extend FriendlyId

    acts_as_paranoid
    acts_as_list column: :priority
    friendly_id :name, use: %i[slugged history]

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :slug, uniqueness: true
    validates_associated :image

    validates :notification_email, email: true, allow_blank: true

    with_options dependent: :destroy do
      has_one :cover_image, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorImage'
      has_one :image, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorImage'
      has_many :commissions, class_name: 'Spree::OrderCommission'
      has_many :vendor_users

      SpreeMultiVendor::Config[:vendorized_models].uniq.compact.each do |model|
        has_many model.pluralize.to_sym
      end
    end

    has_many :orders, class_name: 'Spree::Order', through: :line_items
    has_many :users, through: :vendor_users, class_name: Spree.user_class.to_s
    belongs_to :country, class_name: 'Spree::Country', optional: true

    belongs_to :bill_address, class_name: 'Spree::Address', optional: true
    alias_attribute :billing_address, :bill_address

    belongs_to :ship_address, class_name: 'Spree::Address', optional: true
    alias_attribute :shipping_address, :ship_address

    accepts_nested_attributes_for :ship_address, :bill_address
    attr_accessor :use_billing

    after_create :create_stock_location
    after_update :update_stock_location_names
    before_save :ensure_country
    before_validation :clone_billing_address, if: :use_billing?

    state_machine :status, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    scope :active, -> { where(status: 'active') }
    scope :blocked, -> { where(status: 'blocked') }
    scope :pending, -> { where(status: 'pending') }
    scope :by_country, ->(country_id) { where(country_id: country_id) }

    self.whitelisted_ransackable_attributes = %w[name status]

    def update_notification_email(email)
      update(notification_email: email)
    end

    def customers_count
      orders.complete.distinct.count(:user_id)
    end

    def pending_orders_count
      orders.balance_due.count
    end

    def sales_count
      orders.paid.count
    end

    def sales_total
      orders.paid.map { |order| order.vendor_total(self) }.sum
    end

    def this_month_sales
      orders.paid.this_month.map { |order| order.vendor_total(self) }.sum
    end

    def last_month_sales
      orders.paid.last_month.map { |order| order.vendor_total(self) }.sum
    end

    def last_12_mos_sales
      orders.paid.last_12_mos.map { |order| order.vendor_total(self) }.sum
    end

    def commission_total
      commissions.sum(:amount)
    end

    def commission_total_for(order)
      commissions.where(order: order).sum(:amount)
    end

    private

    def create_stock_location
      stock_locations.where(name: name, country: country).first_or_create!
    end

    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end

    def update_stock_location_names
      stock_locations.update_all({ name: name }) if saved_changes&.include?(:name)
    end

    def ensure_country
      return unless has_attribute?(:country_id)
      return if country.present?

      self.country = Spree::Store.default.default_country || Spree::Country.find_by(iso: 'US')
    end

    def clone_billing_address
      if bill_address && ship_address.nil?
        self.ship_address = bill_address.clone
      else
        ship_address.attributes = bill_address.attributes.except('id', 'updated_at', 'created_at')
      end
      true
    end

    def use_billing?
      use_billing.in?([true, 'true', '1'])
    end
  end
end
