class CreateSpreeFavoriteVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_favorite_vendors do |t|
      t.references :user, null: false, foreign_key: { to_table: :spree_users }
      t.references :vendor, null: false, foreign_key: { to_table: :spree_vendors }
      t.timestamps
    end
  end
end
