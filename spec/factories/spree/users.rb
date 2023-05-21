FactoryBot.define do
  factory :user, class: Spree::User do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'secret' }
    password_confirmation { 'secret' }
  end
end