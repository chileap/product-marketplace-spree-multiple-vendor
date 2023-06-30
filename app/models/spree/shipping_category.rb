# == Schema Information
#
# Table name: spree_shipping_categories
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_spree_shipping_categories_on_name  (name)
#
module Spree
  class ShippingCategory < Spree::Base
    include UniqueName
    if defined?(Spree::Webhooks)
      include Spree::Webhooks::HasWebhooks
    end

    with_options inverse_of: :shipping_category do
      has_many :products
      has_many :shipping_method_categories
    end
    has_many :shipping_methods, through: :shipping_method_categories
  end
end
