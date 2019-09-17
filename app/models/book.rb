class Book < ApplicationRecord
  has_one  :review,    dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :users,      through: :user_books
  paginates_per 20

  validates :image_url, presence: true
  validates :uid,      presence: true
end
