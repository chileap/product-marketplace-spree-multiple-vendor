class AddDescriptionToShippingCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_shipping_categories, :description, :text

    Spree::ShippingCategory.all.each do |shipping_category|
      next if shipping_category.description.present?

      if shipping_category.name == 'Default' || shipping_category.name == 'Physical'
        shipping_category.update(description: 'A tangible item that you will ship to buyers.')
      elsif shipping_category.name == 'Digital'
        shipping_category.update(description: 'An intangible item that you will deliver to buyers via email or download.')
      else
        shipping_category.update(description: shipping_category.name)
      end
    end
  end
end
