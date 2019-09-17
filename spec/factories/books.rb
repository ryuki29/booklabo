FactoryBot.define do
  factory :book do
    title { "タイトル" }
    authors { "著者" }
    image_url { "https://image.url" }
    uid { "1q2w3e4r5t" }
  end
end
