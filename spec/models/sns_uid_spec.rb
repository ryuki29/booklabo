# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SnsUid, type: :model do
  it 'has a valid factory' do
    sns_uid = FactoryBot.build(:sns_uid)
    expect(sns_uid).to be_valid
  end

  it 'is invalid without a provider' do
    sns_uid = FactoryBot.build(:sns_uid, provider: nil)
    sns_uid.valid?
    expect(sns_uid.errors[:provider]).to include('を入力してください')
  end

  it 'is valid when the provider is facebook' do
    sns_uid = FactoryBot.build(:sns_uid, provider: 'facebook')
    expect(sns_uid).to be_valid
  end

  it 'is valid when the provider is google' do
    sns_uid = FactoryBot.build(:sns_uid, provider: 'google')
    expect(sns_uid).to be_valid
  end

  it 'is invalid when the provider is other than twitter, facebook, or google' do
    sns_uid = FactoryBot.build(:sns_uid, provider: 'GitHub')
    sns_uid.valid?
    expect(sns_uid.errors[:provider]).to include('は一覧にありません')
  end

  it 'is invalid when an unique id is not present' do
    sns_uid = FactoryBot.build(:sns_uid, uid: nil)
    sns_uid.valid?
    expect(sns_uid.errors[:uid]).to include('を入力してください')
  end
end
