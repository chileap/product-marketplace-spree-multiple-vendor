class AddBillingAddressAndShippingAddressToVendor < ActiveRecord::Migration[7.0]
  def change
    add_reference :spree_vendors, :bill_address, index: true, foreign_key: { to_table: :spree_addresses }
    add_reference :spree_vendors, :ship_address, index: true, foreign_key: { to_table: :spree_addresses }
  end
end
