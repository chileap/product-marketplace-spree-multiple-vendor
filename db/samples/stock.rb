Spree::Sample.load_sample('variants')

location = Spree::StockLocation.find_by!(name: 'Default Vendor')
Spree::StockLocations::StockItems::Create.call(stock_location: location)

product_1 = Spree::Product.find_by!(name: 'Denim Shirt')
product_2 = Spree::Product.find_by!(name: 'Checked Shirt')

location.stock_item_or_create(product_1.master).update(count_on_hand: 1)
location.stock_item_or_create(product_2.master).update(count_on_hand: 1)

Spree::Variant.all.each do |variant|
  next if variant.is_master? && variant.product.has_variants?

  variant.stock_items.each do |stock_item|
    Spree::StockMovement.create(quantity: rand(20..50), stock_item: stock_item)
  end
end
