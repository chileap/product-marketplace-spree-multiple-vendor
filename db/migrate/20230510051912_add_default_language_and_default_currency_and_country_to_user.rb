class AddDefaultLanguageAndDefaultCurrencyAndCountryToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :default_language, :string, default: 'en'
    add_column :spree_users, :default_currency, :string, default: 'USD'
    add_column :spree_users, :default_country, :string, default: 'US'
    add_column :spree_users, :default_city, :string

    add_index :spree_users, :default_language
    add_index :spree_users, :default_currency
    add_index :spree_users, :default_country
  end
end
