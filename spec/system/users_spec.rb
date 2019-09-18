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
end
