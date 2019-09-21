class Book < ApplicationRecord
  has_one  :review,    dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :users,      through: :user_books
  paginates_per 20

  validates :image_url, presence: true
  validates :uid,       presence: true

  private
  def self.search_books(keyword, page)
    encoded_uri = URI.encode(
      "https://www.googleapis.com/books/v1/volumes?maxResults=20&startIndex=#{page}&q=#{keyword}&fields=totalItems,items(id,volumeInfo(title,authors,imageLinks/thumbnail))"
    )
    parsed_uri = URI.parse(encoded_uri)
    result = JSON.parse(Net::HTTP.get(parsed_uri))
    return result
  end
end
