FactoryBot.define do
  factory :review do
    date { Date.today }
    text { "面白かった" }
    rating { 3 }
    association :book
    association :user
  end
end
