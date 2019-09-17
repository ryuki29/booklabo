require 'rails_helper'

RSpec.describe Book, type: :model do
  it "has a valid factory" do
    book = FactoryBot.build(:book)
    expect(book).to be_valid
  end

  it "is invalid without a uid" do
    book = FactoryBot.build(
      :book,
      uid: nil
    )
    book.valid?
    expect(book.errors[:uid]).to include("を入力してください")
  end

  it "is invalid without a image_url" do
    book = FactoryBot.build(
      :book,
      image_url: nil
    )
    book.valid?
    expect(book.errors[:image_url]).to include("を入力してください")
  end
end
