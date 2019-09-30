# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserBook, type: :model do
  it 'has a valid factory' do
    user_book = FactoryBot.build(:user_book)
    expect(user_book).to be_valid
  end

  it 'is invalid when the status is 3' do
    user_book = FactoryBot.build(:user_book, status: 3)
    user_book.valid?
    expect(user_book.errors[:status]).to include('は2以下の値にしてください')
  end
end
