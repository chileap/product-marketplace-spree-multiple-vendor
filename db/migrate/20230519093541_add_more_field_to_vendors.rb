class AddMoreFieldToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_vendors, :shop_locale, :string, default: 'en'
    add_column :spree_vendors, :shop_currency, :string, default: 'USD'

    add_index :spree_vendors, :shop_locale
    add_index :spree_vendors, :shop_currency
  end
end
