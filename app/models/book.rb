class Book < ApplicationRecord
  has_one  :review,    dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :users,      through: :user_books
end
