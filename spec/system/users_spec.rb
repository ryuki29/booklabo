require 'rails_helper'

describe 'Users', type: :system do
  describe "新規登録機能" do
    it "名前とメールアドレス、パスワードを入力・送信すると、新規ユーザーが作成される" do
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

    describe "SNS認証での新規登録" do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:twitter] = nil
        OmniAuth.config.mock_auth[:facebook] = nil
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          :provider => 'twitter',
          :uid => 'twitter-new-uid',
          :info => { :nickname => "twitter-user" },
          :credentials => {
            :token => "twitter-token-12345678",
            :secret => "twitter-secret-12345678"
          }
        })
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => 'facebook-new-uid',
          :info => {
            :name => "facebook-user",
            :email => "facebook-signup@example.com"
          }
        })
      end

      it "Twitterアカウントで新規登録できる" do
        expect do
          visit new_user_registration_path
          click_link 'signup-twitter'
          expect(page).to have_selector ".user-show"
          expect(page).to have_content "twitter-user"
          expect(page).to have_content "プロフィールを編集"
        end.to change(User, :count).by(1)
           .and change(SnsUid, :count).by(1)
      end

      it "Facebookアカウントで新規登録できる" do
        expect do
          visit new_user_registration_path
          click_link 'signup-facebook'
          expect(page).to have_selector ".user-show"
          expect(page).to have_content "facebook-user"
          expect(page).to have_content "プロフィールを編集"
        end.to change(User, :count).by(1)
           .and change(SnsUid, :count).by(1)
      end
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

    it "テストユーザーでログインできる" do
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

    describe "SNS認証でのログイン機能" do
      before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:twitter] = nil
        OmniAuth.config.mock_auth[:facebook] = nil
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          :provider => 'twitter',
          :uid => 'twitter-signin-uid',
          :info => { :nickname => "twitter-user" },
          :credentials => {
            :token => "twitter-token-12345678",
            :secret => "twitter-secret-12345678"
          }
        })
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => 'facebook-signin-uid',
          :info => {
            :name => "facebook-user",
            :email => "facebook-signin@example.com"
          }
        })
      end

      it "Twitterアカウントでログインできる" do
        user = FactoryBot.create(:user, name: "twitter-user")
        FactoryBot.create(
          :sns_uid,
          provider: 'twitter',
          uid: 'twitter-signin-uid',
          user: user
        )

        expect do
          visit new_user_session_path
          click_link 'signin-twitter'
          expect(page).to have_selector ".user-show"
          expect(page).to have_content "twitter-user"
          expect(page).to have_content "プロフィールを編集"
        end.to_not change(User, :count)
      end

      it "Facebookアカウントでログインできる" do
        user = FactoryBot.create(:user, name: "facebook-user")
        FactoryBot.create(
          :sns_uid,
          provider: 'facebook',
          uid: 'facebook-signin-uid',
          user: user
        )

        expect do
          visit new_user_session_path
          click_link 'signin-facebook'
          expect(page).to have_selector ".user-show"
          expect(page).to have_content "facebook-user"
          expect(page).to have_content "プロフィールを編集"
        end.to_not change(User, :count)
      end
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

  describe "フォロー機能" do
    let(:follower) { FactoryBot.create(:user, name: "Alice") }
    let(:followed) { FactoryBot.create(:user, name: "Bob") }

    it "他のユーザーをフォローできる" do
      sign_in(follower)
      visit user_path(followed)
      expect(find('#followed').text).to eq("0")
      expect do
        find('.follow-btn').click
        expect(page).to have_css('.follow-btn.following')
      end.to change(Relationship, :count).by(1)
      expect(find('#followed').text).to eq("1")
      find('#show-followers').click
      expect(page).to have_content(follower.name)
      find('.follower-name').click

      expect(page).to have_content(follower.name)
      expect(find('#following').text).to eq("1")
    end
  end
end
