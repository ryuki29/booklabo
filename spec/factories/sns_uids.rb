FactoryBot.define do
  factory :sns_uid do
    provider { "twitter" }
    uid { 123456789012345678 }
    association :user
  end
end
