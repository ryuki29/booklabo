require 'rails_helper'

describe 'Books', type: :system do
  describe "本の検索機能" do
    before do
      user = FactoryBot.create(:user)
      sign_in(user)
      json = {
        "totalItems" => 1,
        "items" =>
         [{"id"=>"MXJT-12RchcC",
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

  describe "本の登録機能" do
    let(:user) { FactoryBot.create(:user) }

    before do
      json = {
        "totalItems" => 1,
        "items" =>
         [{"id"=>"MXJT-12RchcC",
           "volumeInfo"=>
            {"title"=>"坊っちゃん",
             "authors"=>["夏目漱石"],
             "imageLinks"=>{"thumbnail"=>"http://books.google.com/books/content?id=MXJT-12RchcC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"}}}]}
      allow(Book).to receive(:search_books).and_return(json)

      sign_in(user)
      visit root_path
      fill_in 'keyword', with: '夏目漱石'
      click_button 'search-submit'
      expect(page).to_not have_content "本を登録する"
      find('.add-book-cover').hover
      expect(page).to have_content "本を登録する"
      find(".add-book").click
    end

    it "読んだ本を登録できる" do
      expect do
        find("#read-book").click
        expect(page).to have_content "読んだ本に登録する"
        fill_in "review-text", with: "レビュー機能の統合テスト"
        click_button "review-submit"

        expect(page).to have_selector ".user-show"
        expect(page).to have_content user.name
        expect(page).to have_css('#read.active')
        expect(page).to have_content "坊っちゃん"
      end.to  change(Book, :count).by(1)
         .and change(Review, :count).by(1)
         .and change(UserBook, :count).by(1)
    end

    it "読みたい本を登録できる" do
      expect do
        find("#will-read-book").click
        expect(page).to have_selector ".user-show"
        expect(page).to have_content user.name
        expect(page).to have_css('#will-read.active')
        expect(page).to have_content "坊っちゃん"
      end.to  change(Book, :count).by(1)
         .and change(UserBook, :count).by(1)
    end

    it "読んでる本を登録できる" do
      expect do
        find("#reading-book").click
        expect(page).to have_selector ".user-show"
        expect(page).to have_content user.name
        expect(page).to have_css('#reading.active')
        expect(page).to have_content "坊っちゃん"
      end.to  change(Book, :count).by(1)
         .and change(UserBook, :count).by(1)
    end
  end
end
