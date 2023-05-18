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
#  slug               :string
#  state_name         :string
#  status             :string
#  zipcode            :string
#  created_at         :datetime
#  updated_at         :datetime
#  country_id         :integer
#  state_id           :integer
#
# Indexes
#
#  index_spree_vendors_on_deleted_at  (deleted_at)
#  index_spree_vendors_on_name        (name) UNIQUE
#  index_spree_vendors_on_slug        (slug) UNIQUE
#  index_spree_vendors_on_status      (status)
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

    after_create :create_stock_location
    after_update :update_stock_location_names
    before_save :ensure_country

    state_machine :status, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    scope :active, -> { where(status: 'active') }
    scope :by_country, ->(country_id) { where(country_id: country_id) }

    self.whitelisted_ransackable_attributes = %w[name status]

    def update_notification_email(email)
      update(notification_email: email)
    end

    def customers_count
      orders.complete.distinct.count(:user_id)
    end

    def pending_orders_count
      orders.where(payment_state: :balance_due).count
    end

    def sales_count
      orders.where(payment_state: :paid).count
    end

    def sales_total
      orders.where(payment_state: :paid).map { |order| order.vendor_total(self) }.sum
    end

    def this_month_sales
      orders.where(payment_state: :paid).where(completed_at: Time.current.beginning_of_month..Time.current.end_of_month).map { |order| order.vendor_total(self) }.sum
    end

    def last_month_sales
      orders.where(payment_state: :paid).where(completed_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month).map { |order| order.vendor_total(self) }.sum
    end

    def last_12_mos_sales
      orders.where(payment_state: :paid).where(completed_at: 12.months.ago.beginning_of_month..Time.current.end_of_month).map { |order| order.vendor_total(self) }.sum
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
  end
end
