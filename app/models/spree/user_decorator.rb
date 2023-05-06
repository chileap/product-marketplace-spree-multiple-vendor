module Spree::UserDecorator
  def self.prepended(base)
    base.validates :first_name, presence: true
  end
end

Spree.user_class.prepend Spree::UserDecorator
