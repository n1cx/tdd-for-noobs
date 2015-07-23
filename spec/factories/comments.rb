# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    subject "MyString"
    content "MyText"
    email { "MyEmail"+"@readflyer.com" }
    article_id 1
  end
end
