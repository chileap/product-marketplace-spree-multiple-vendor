class AddCountryIdAndAddressFieldsToVendors < ActiveRecord::Migration[7.0]
  def change
    rename_column :spree_vendors, :state, :status

    add_column :spree_vendors, :country_id, :integer
    add_column :spree_vendors, :address1, :string
    add_column :spree_vendors, :address2, :string
    add_column :spree_vendors, :city, :string
    add_column :spree_vendors, :state_id, :integer
    add_column :spree_vendors, :state_name, :string
    add_column :spree_vendors, :zipcode, :string
    add_column :spree_vendors, :phone, :string


    Spree::Vendor.all.each do |vendor|
      default_stock_location = vendor.stock_locations.find_by(default: true) || vendor.stock_locations.first
      vendor.update(country_id: default_stock_location.country_id)
    end
  end
end
