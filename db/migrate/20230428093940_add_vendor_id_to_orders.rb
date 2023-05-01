class AddVendorIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :spree_orders, :vendor, index: true
  end
end
