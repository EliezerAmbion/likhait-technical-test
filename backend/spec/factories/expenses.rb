FactoryBot.define do
  factory :expense do
    description { "MyString" }
    amount { 9.99 }
    association :category
    date { Date.current }
    payer_name { "MyString" }
  end
end
