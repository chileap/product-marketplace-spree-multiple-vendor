class AddVendorToLineItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :spree_line_items, :vendor, index: true
  end
end
