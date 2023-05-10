class AddSlugToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :slug, :string
    add_index :spree_users, :slug, unique: true

    Spree::User.all.each do |user|
      user.first_name = user.email.split('@').first
      user.save
    end
  end
end
