require 'rails_helper'

describe 'Users', type: :system do
  describe "新規登録機能" do
    it "名前、メールアドレス、パスワードをフォームに入力し、「登録する」をクリックすると、新規ユーザーが作成され、ユーザー詳細ページにリダイレクトされる" do
      expect do
        visit new_user_registration_path
        fill_in 'user_name', with: 'testuser'
        fill_in 'user_email', with: 'test1234@example.com'
        fill_in 'user_password', with: 'test1234'
        fill_in 'user_password_confirmation', with: 'test1234'
        click_button '登録する'

        expect(page).to have_selector ".user-show"
        expect(page).to have_content "testuser"
        expect(page).to have_content "プロフィールを編集"
      end.to change(User, :count).by(1)
    end
  end

  describe "ログイン機能" do
    let(:user) {
      FactoryBot.create(
        :user,
        password: "test1234",
        password_confirmation: "test1234"
      )
    }

    it "既存のユーザーでログインできる" do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: "test1234"
      click_button 'ログインする'

      expect(page).to have_selector ".user-show"
      expect(page).to have_content user.name
      expect(page).to have_content "プロフィールを編集"
    end

    it "テストユーザーでログインできる", js: true do
      User.create(
        name: "テストユーザー",
        email: "testuser1@email.com",
        password: "testuser1",
        password_confirmation: "testuser1"
      )

      visit new_user_session_path
      click_button 'テストユーザーでログイン'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_selector ".user-show"
      expect(page).to have_content "テストユーザー"
      expect(page).to have_content "プロフィールを編集"
    end
  end

  describe "ログアウト機能" do
    it "ユーザーがログアウトできる" do
      user = FactoryBot.create(:user)
      sign_in(user)

      visit root_path
      expect(page).to have_link 'users-sign-out-link'
      click_link 'users-sign-out-link'
      expect(page).to have_button "ログインする"
    end
  end
end
