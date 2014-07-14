# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    title   { Faker::Lorem.characters(5) }
    text    { Faker::Lorem.paragraph }
  end
end
