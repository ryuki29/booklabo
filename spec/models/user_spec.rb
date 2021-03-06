# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include('を入力してください')
  end

  it 'is valid with a name with 20 characters' do
    user = FactoryBot.build(:user, name: 'アイウエオカキクケコサシスセソタチツテト')
    expect(user).to be_valid
  end

  it 'is invalid with a name with 20 characters' do
    user = FactoryBot.build(:user, name: 'アイウエオカキクケコサシスセソタチツテトナ')
    user.valid?
    expect(user.errors[:name]).to include('は20文字以内で入力してください')
  end

  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, email: 'test@example.com')
    user = FactoryBot.build(:user, email: 'test@example.com')
    user.valid?
    expect(user.errors[:email]).to include('はすでに存在します')
  end

  it 'is invalid with an email address with an invalid format' do
    user = FactoryBot.build(:user, email: 'invalidemail')
    user.valid?
    expect(user.errors[:email]).to include('のフォーマットが不適切です')
  end

  it 'is invalid without a password' do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include('を入力してください')
  end

  it 'is invalid with a password with 6 characters' do
    user = FactoryBot.build(
      :user,
      password: 'pass12',
      password_confirmation: 'pass12'
    )
    user.valid?
    expect(user.errors[:password]).to include('は7文字以上で入力してください')
  end

  it 'is valid with a password with 7 characters' do
    user = FactoryBot.build(
      :user,
      password: 'pass123',
      password_confirmation: 'pass123'
    )
    expect(user).to be_valid
  end

  it 'is valid with a password with 128 characters' do
    user = FactoryBot.build(
      :user,
      password: 'a1' * 64,
      password_confirmation: 'a1' * 64
    )
    expect(user).to be_valid
  end

  it 'is invalid with a password with 129 characters' do
    user = FactoryBot.build(
      :user,
      password: 'a1' * 64 + 'a',
      password_confirmation: 'a1' * 64 + 'a'
    )
    user.valid?
    expect(user.errors[:password]).to include('は128文字以内で入力してください')
  end

  it "is invalid when the password doesn't match with the confirmation" do
    user = FactoryBot.build(
      :user,
      password: 'password1',
      password_confirmation: 'password2'
    )
    user.valid?
    expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
  end

  it 'is valid with a url with 100 characters' do
    user = FactoryBot.build(
      :user,
      url: 'https://' + 'a' * 92
    )
    expect(user).to be_valid
  end

  it 'is invalid with a url with 101 characters' do
    user = FactoryBot.build(
      :user,
      url: 'https://' + 'a' * 93
    )
    user.valid?
    expect(user.errors[:url]).to include('は100文字以内で入力してください')
  end

  it 'is invalid with a url in an invalid format' do
    user = FactoryBot.build(
      :user,
      url: 'http:/invalid.com'
    )
    user.valid?
    expect(user.errors[:url]).to include('のフォーマットが不適切です')
  end

  it 'is valid with a desription with 160 characters' do
    user = FactoryBot.build(
      :user,
      description: 'あ' * 160
    )
    expect(user).to be_valid
  end

  it 'is invalid with a discription with 161 characters' do
    user = FactoryBot.build(
      :user,
      description: 'あ' * 161
    )
    user.valid?
    expect(user.errors[:description]).to include('は160文字以内で入力してください')
  end
end
