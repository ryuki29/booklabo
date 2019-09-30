# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'has a valid factory' do
    review = FactoryBot.build(:review)
    expect(review).to be_valid
  end

  it 'is invalid when the date is after tomorrow' do
    review = FactoryBot.build(:review, date: Date.today + 1)
    review.valid?
    expect(review.errors[:date]).to include('は本日以前の日付を選択してください')
  end

  it 'is valid when the text has 255 characters' do
    review = FactoryBot.build(
      :review,
      text: 'a' * 255
    )
    expect(review).to be_valid
  end

  it 'is invalid when the text has 256 characters' do
    review = FactoryBot.build(
      :review,
      text: 'a' * 256
    )
    review.valid?
    expect(review.errors[:text]).to include('は255文字以内で入力してください')
  end

  it 'is invalid when the rating is -1' do
    review = FactoryBot.build(
      :review,
      rating: -1
    )
    review.valid?
    expect(review.errors[:rating]).to include('は0以上の値にしてください')
  end

  it 'is valid when the rating is 0' do
    review = FactoryBot.build(
      :review,
      rating: 0
    )
    expect(review).to be_valid
  end

  it 'is valid when the rating is 5' do
    review = FactoryBot.build(
      :review,
      rating: 5
    )
    expect(review).to be_valid
  end

  it 'is invalid when the rating is 6' do
    review = FactoryBot.build(
      :review,
      rating: 6
    )
    review.valid?
    expect(review.errors[:rating]).to include('は6より小さい値にしてください')
  end
end
