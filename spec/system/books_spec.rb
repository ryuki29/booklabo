require 'rails_helper'

describe 'Books', type: :system do
  describe "本の検索機能" do
    before do
      user = FactoryBot.create(:user)
      sign_in(user)
      json =  {"totalItems"=>2173,
        "items"=>
         [{"id"=>"ve4UAQAAMAAJ",
           "volumeInfo"=>
            {"title"=>"日本人が知らない夏目漱石",
             "authors"=>["ダミアン・フラナガン"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=ve4UAQAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"}}},
          {"id"=>"Jb3GNmCzcIoC",
           "volumeInfo"=>
            {"title"=>"こころ",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=Jb3GNmCzcIoC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"KBaI93Htv0MC",
           "volumeInfo"=>
            {"title"=>"増補夏目漱石の作品研究",
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=KBaI93Htv0MC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"MEdzNrAX-yUC",
           "volumeInfo"=>
            {"title"=>"三四郎",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=MEdzNrAX-yUC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"y01NAAAAMAAJ",
           "volumeInfo"=>
            {"title"=>"夏目漱石",
             "authors"=>["松元寬", "夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=y01NAAAAMAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"}}},
          {"id"=>"GRLnBgAAQBAJ",
           "volumeInfo"=>
            {"title"=>"門",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=GRLnBgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"_mTdDQAAQBAJ",
           "volumeInfo"=>
            {"title"=>"明暗",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=_mTdDQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"atJWDwAAQBAJ",
           "volumeInfo"=>
            {"title"=>"夏目漱石とクラシック音楽（毎日新聞出版）",
             "authors"=>["瀧井敬子"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=atJWDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"OZ0QTG-LVzgC",
           "volumeInfo"=>
            {"title"=>"謎とき・坊っちゃん",
             "authors"=>["石原豪人"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=OZ0QTG-LVzgC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"DCwbCgAAQBAJ",
           "volumeInfo"=>
            {"title"=>"夏目漱石　後期三部作",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=DCwbCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"-bo5rcZffBcC",
           "volumeInfo"=>
            {"title"=>"夏目漱石先生の追憶",
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=-bo5rcZffBcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"bWXdDQAAQBAJ",
           "volumeInfo"=>
            {"title"=>"行人",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=bWXdDQAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"G3Y4DAAAQBAJ",
           "volumeInfo"=>
            {"title"=>"夏目漱石　前期三部作",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=G3Y4DAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"q4N6swEACAAJ",
           "volumeInfo"=>
            {"title"=>"漱石全集",
             "authors"=>["夏目漱石", "夏目金之助"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=q4N6swEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"}}},
          {"id"=>"JyEpCgAAQBAJ",
           "volumeInfo"=>
            {"title"=>"草枕",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=JyEpCgAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"sHqCM1XM8v8C",
           "volumeInfo"=>
            {"title"=>"こころ",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=sHqCM1XM8v8C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"LpyO4v9ow88C",
           "volumeInfo"=>
            {"title"=>"自転車日記",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=LpyO4v9ow88C&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"JzBNAQAAIAAJ",
           "volumeInfo"=>
            {"title"=>"夏目漱石「自意識」の罠",
             "authors"=>["松尾直昭"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=JzBNAQAAIAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"}}},
          {"id"=>"1vByCwAAQBAJ",
           "volumeInfo"=>
            {"title"=>"野分",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=1vByCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}},
          {"id"=>"MXJT-12RchcC",
           "volumeInfo"=>
            {"title"=>"坊っちゃん",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=MXJT-12RchcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}}]}
      allow(Book).to receive(:search_books).and_return(json)
    end

    it "ヘッダーの検索フォームから本を検索できる" do
      visit root_path
      fill_in 'keyword', with: '夏目漱石'
      click_button 'search-submit'
      expect(Book).to have_received(:search_books).once
      expect(page).to have_content '検索結果'
      expect(page).to have_content '夏目漱石'
    end

    it "空欄のまま検索すると、GoogleBooksAPIへのリクエストが送られない" do
      visit root_path
      fill_in 'keyword', with: ''
      click_button 'search-submit'
      expect(Book).to_not have_received(:search_books)
      expect(page).to have_content '検索結果'
    end
  end
end