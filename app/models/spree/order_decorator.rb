module Spree::OrderDecorator
  def self.prepended(base)
    base.scope :paid, -> { where(payment_state: :paid) }
    base.scope :balance_due, -> { where(payment_state: :balance_due) }
    base.scope :this_month, -> { where(completed_at: 1.month.ago.beginning_of_month..Time.current.end_of_month) }
    base.scope :last_month, -> { where(completed_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
    base.scope :last_12_mos, -> { where(completed_at: 12.months.ago.beginning_of_month..Time.current.end_of_month) }
  end
end

Spree::Order.prepend Spree::OrderDecorator
