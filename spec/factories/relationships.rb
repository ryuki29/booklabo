FactoryBot.define do
  factory :relationship do
    association :follower, factory: :user, email: "follower@email.com"
    association :followed, factory: :user, email: "followed@email.com"
  end
end
