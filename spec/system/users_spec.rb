# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :system do
  describe '新規登録機能' do
    it '名前とメールアドレス、パスワードを入力・送信すると、新規ユーザーが作成される' do
      expect do
        visit new_user_registration_path
        fill_in 'user_name', with: 'testuser'
        fill_in 'user_email', with: 'test1234@example.com'
        fill_in 'user_password', with: 'test1234'
        fill_in 'user_password_confirmation', with: 'test1234'
        click_button '登録する'

        expect(page).to have_selector '.user-show'
        expect(page).to have_content 'testuser'
        expect(page).to have_content 'プロフィールを編集'
      end.to change(User, :count).by(1)
    end

    describe 'SNS認証での新規登録' do
      before do
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:twitter] = nil
        OmniAuth.config.mock_auth[:facebook] = nil
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
          provider: 'twitter',
          uid: 'twitter-new-uid',
          info: { nickname: 'twitter-user' },
          credentials: {
            token: 'twitter-token-12345678',
            secret: 'twitter-secret-12345678'
          }
        )
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
          provider: 'facebook',
          uid: 'facebook-new-uid',
          info: {
            name: 'facebook-user',
            email: 'facebook-signup@example.com'
          }
        )
      end

      it 'Twitterアカウントで新規登録できる' do
        expect do
          visit new_user_registration_path
          click_link 'signup-twitter'
          expect(page).to have_selector '.user-show'
          expect(page).to have_content 'twitter-user'
          expect(page).to have_content 'プロフィールを編集'
        end.to change(User, :count).by(1)
                                   .and change(SnsUid, :count).by(1)
      end

      it 'Facebookアカウントで新規登録できる' do
        expect do
          visit new_user_registration_path
          click_link 'signup-facebook'
          expect(page).to have_selector '.user-show'
          expect(page).to have_content 'facebook-user'
          expect(page).to have_content 'プロフィールを編集'
        end.to change(User, :count).by(1)
                                   .and change(SnsUid, :count).by(1)
      end

      it 'ユーザーがSNSアカウントを持たない場合、ログインページにリダイレクトされる' do
        allow(User).to receive(:find_for_oauth).and_return(nil)
        visit new_user_registration_path
        click_link 'signup-twitter'
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  describe 'ログイン機能' do
    let(:user) do
      FactoryBot.create(
        :user,
        password: 'test1234',
        password_confirmation: 'test1234'
      )
    end

    it '既存のユーザーでログインできる' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'test1234'
      click_button 'ログインする'

      expect(page).to have_selector '.user-show'
      expect(page).to have_content user.name
      expect(page).to have_content 'プロフィールを編集'
    end

    it 'テストユーザーでログインできる' do
      User.create(
        name: 'テストユーザー',
        email: 'testuser1@email.com',
        password: 'testuser1',
        password_confirmation: 'testuser1'
      )

      visit new_user_session_path
      click_button 'テストユーザーでログイン'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_selector '.user-show'
      expect(page).to have_content 'テストユーザー'
      expect(page).to have_content 'プロフィールを編集'
    end

    describe 'SNS認証でのログイン機能' do
      before do
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:twitter] = nil
        OmniAuth.config.mock_auth[:facebook] = nil
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
          provider: 'twitter',
          uid: 'twitter-signin-uid',
          info: { nickname: 'twitter-user' },
          credentials: {
            token: 'twitter-token-12345678',
            secret: 'twitter-secret-12345678'
          }
        )
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
          provider: 'facebook',
          uid: 'facebook-signin-uid',
          info: {
            name: 'facebook-user',
            email: 'facebook-signin@example.com'
          }
        )
      end

      it 'Twitterアカウントでログインできる' do
        user = FactoryBot.create(:user, name: 'twitter-user')
        FactoryBot.create(
          :sns_uid,
          provider: 'twitter',
          uid: 'twitter-signin-uid',
          user: user
        )

        expect do
          visit new_user_session_path
          click_link 'signin-twitter'
          expect(page).to have_selector '.user-show'
          expect(page).to have_content 'twitter-user'
        end.to_not change(User, :count)
      end

      it 'Facebookアカウントでログインできる' do
        user = FactoryBot.create(:user, name: 'facebook-user')
        FactoryBot.create(
          :sns_uid,
          provider: 'facebook',
          uid: 'facebook-signin-uid',
          user: user
        )

        expect do
          visit new_user_session_path
          click_link 'signin-facebook'
          expect(page).to have_selector '.user-show'
          expect(page).to have_content 'facebook-user'
        end.to_not change(User, :count)
      end

      context 'Facebookのメールアドレスで既にユーザー登録されている場合' do
        before do
          OmniAuth.config.mock_auth[:facebook] = nil
          OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
            provider: 'facebook',
            uid: 'facebook-signin-uid',
            info: {
              name: 'facebook-user',
              email: 'facebook-user@example.com'
            }
          )
          FactoryBot.create(:user, name: '登録済みのユーザー名', email: 'facebook-user@example.com')
        end

        it 'FacebookのIDのみ登録される' do
          visit new_user_session_path
          expect do
            click_link 'signin-facebook'
          end.to change(User, :count).by(0)
                                     .and change(SnsUid, :count).by(1)
          expect(page).to have_selector '.user-show'
          expect(page).to have_content '登録済みのユーザー名'
        end
      end
    end
  end

  describe 'ログアウト機能' do
    it 'ユーザーがログアウトできる' do
      user = FactoryBot.create(:user)
      sign_in(user)

      visit root_path
      expect(page).to have_link 'users-sign-out-link'
      click_link 'users-sign-out-link'
      expect(page).to have_button 'ログインする'
    end
  end

  describe 'フォロー機能' do
    let(:follower) { FactoryBot.create(:user, name: 'Alice') }
    let(:followed) { FactoryBot.create(:user, name: 'Bob') }

    it '他のユーザーをフォローできる' do
      sign_in(follower)
      visit user_path(followed)
      expect(find('#followed').text).to eq('0')
      expect do
        find('.follow-btn').click
        expect(page).to have_css('.follow-btn.following')
      end.to change(Relationship, :count).by(1)
      expect(find('#followed').text).to eq('1')
      find('#show-followers').click
      expect(page).to have_content(follower.name)
      find('.follower-name').click

      expect(page).to have_content(follower.name)
      expect(find('#following').text).to eq('1')
      find('#show-following').click
      find('.follower-name').click
      expect(page).to have_content(followed.name)

      expect do
        find('.follow-btn').click
        expect(page).to_not have_css('.follow-btn.following')
      end.to change(Relationship, :count).by(-1)
      expect(find('#followed').text).to eq('0')
    end
  end

  describe 'プロフィールの編集機能' do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in(user)
    end

    it 'プロフィールを編集できる' do
      visit user_path(user)
      expect(page).to have_content 'プロフィールを編集'
      find('#edit-profile').click
      find('#user_image', visible: false).attach_file('tmp/images/test-user-image.jpg')
      fill_in 'edit-user-name', with: '編集済みのユーザー名'
      fill_in 'edit-user-description', with: 'テストユーザーの自己紹介です'
      fill_in 'edit-user-url', with: 'https://testuser.com'
      expect do
        click_button '保存'
      end.to change(ActiveStorage::Blob, :count).by(1)
                                                .and change(ActiveStorage::Attachment, :count).by(1)
      expect(page).to have_css("img[src*='test-user-image.jpg']")
      expect(page).to have_content '編集済みのユーザー名'
      expect(page).to have_content 'テストユーザーの自己紹介です'
    end
  end
end
