FactoryBot.define do
  factory :book do
    title { "坊っちゃん" }
    authors { "夏目漱石" }
    image_url { "http://books.google.com/books/content?id=MXJT-12RchcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api" }
    uid { "1q2w3e4r5t" }
  end
end
