default_store = Spree::Store.default
default_store.name = 'Product Mall'
default_store.code = 'product-mall'
default_store.seo_title = 'Product Mall'
default_store.meta_description = 'Product Mall'
default_store.facebook = nil
default_store.twitter = nil
default_store.instagram = nil
default_store.checkout_zone = Spree::Zone.find_by(name: 'North America')
default_store.default_country = Spree::Country.find_by(iso: 'US')
default_store.supported_currencies = 'CAD,USD'
default_store.supported_locales = 'en,fr'
default_store.url = Rails.env.development? ? 'localhost:4000' : 'product-mall.herokuapp.com'
default_store.save!

currencies = %w[EUR GBP CAD]
Spree::Price.where(currency: 'USD').each do |price|
  currencies.each do |currency|
    new_price = Spree::Price.find_or_initialize_by(currency: currency, variant: price.variant)
    new_price.amount = if %w[EUR GBP].include?(currency)
                         price.amount * 0.8
                       else
                         price.amount * 1.2
                       end
    new_price.save
  end
end

Spree::PaymentMethod.all.each do |payment_method|
  payment_method.stores = Spree::Store.all
end

if defined?(Spree::StoreProduct) && Spree::Product.method_defined?(:stores)
  Spree::Product.all.each do |product|
    product.store_ids = Spree::Store.ids
    product.save
  end
end
