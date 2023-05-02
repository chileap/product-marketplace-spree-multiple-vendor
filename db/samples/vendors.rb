user = Spree::User.find_or_initialize_by(email: 'user@vendor.com')
user.password = 'password'
user.password_confirmation = 'password'
user.save!

vendor = Spree::Vendor.find_or_initialize_by(name: 'Default Vendor')
vendor.state = 'active'
vendor.users << user
vendor.save!

Spree::Product.all.each do |product|
  product.vendor = vendor
  product.save
end
