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
        expect(page).to_not have_selector "#tweet-btn"
        fill_in "review-text", with: "レビュー機能の統合テスト"
        click_button "review-submit"

        expect(page).to have_selector ".user-show"
        expect(page).to have_content user.name
        expect(page).to have_css '#read.active'
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
        expect(page).to have_css '#will-read.active'
        expect(page).to have_content "坊っちゃん"
      end.to  change(Book, :count).by(1)
         .and change(UserBook, :count).by(1)
    end

    it "読んでる本を登録できる" do
      expect do
        find("#reading-book").click
        expect(page).to have_selector ".user-show"
        expect(page).to have_content user.name
        expect(page).to have_css '#reading.active'
        expect(page).to have_content "坊っちゃん"
      end.to  change(Book, :count).by(1)
         .and change(UserBook, :count).by(1)
    end
  end

  describe "Twitterへの同時投稿機能" do
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

      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = nil
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        :provider => 'twitter',
        :uid => 'twitter-post-review-uid',
        :info => { :nickname => "twitter-user" },
        :credentials => {
          :token => "twitter-token-12345678",
          :secret => "twitter-secret-12345678"
        }
      })
      FactoryBot.create(
        :sns_uid,
        provider: 'twitter',
        uid: 'twitter-post-review-uid',
        user: user
      )
      visit new_user_session_path
      click_link 'signin-twitter'

      visit root_path
      fill_in 'keyword', with: '夏目漱石'
      click_button 'search-submit'
      find('.add-book-cover').hover
      find(".add-book").click
      find("#read-book").click
    end

    it "レビューをTwitterに同時投稿できる" do
      expect do
        fill_in "review-text", with: "レビュー機能の統合テスト"
        expect(page).to have_selector("#tweet-btn")
        find("#tweet-btn").click
        click_button "review-submit"

        twitter_client_mock = double('Twitter client')
        allow(SnsUid).to receive(:create_twitter_client).and_return(twitter_client_mock)
        expect(twitter_client_mock).to receive(:update)

        expect(page).to have_selector ".user-show"
        expect(page).to have_content user.name
        expect(page).to have_css '#read.active'
        expect(page).to have_content "坊っちゃん"
      end.to  change(Book, :count).by(1)
         .and change(Review, :count).by(1)
         .and change(UserBook, :count).by(1)
    end
  end

  describe "本の編集機能および削除機能" do
    let(:user) { FactoryBot.create(:user) }
    let(:book) { FactoryBot.create(:book) }

    context "読んだ本が登録されている場合" do
      before do
        FactoryBot.create(:user_book, status: 0, user: user, book: book)
        FactoryBot.create(:review, user: user, book: book)
        sign_in(user)
      end

      it "読んだ本のレビューを編集できる" do
      end
  
      it "読んだ本を削除できる" do
        visit user_path(user)
        expect(page).to have_content(book.title)
        find('.users-show-book-img').click
        expect(page).to have_content("削除")

        expect do
          find('#delete-read-book').click
          page.driver.browser.switch_to.alert.accept
          expect(page).to_not have_content(book.title)
        end.to change(Book, :count).by(-1)
      end
    end

    context "読みたい本が登録されている場合" do
      it "読みたい本を削除できる" do
      end
    end

    context "読んでる本が登録されている場合" do
      it "読んでる本を削除できる" do
      end
    end
  end
end
