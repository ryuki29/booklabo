# frozen_string_literal: true

class Book < ApplicationRecord
  has_one  :review, dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :users,      through: :user_books
  paginates_per 20

  validates :image_url, presence: true
  validates :uid,       presence: true

  def self.search_books(keyword, page)
    encoded_uri = Addressable::URI.encode(
      "https://www.googleapis.com/books/v1/volumes?maxResults=20&startIndex=#{page}&q=#{keyword}&fields=totalItems,items(id,volumeInfo(title,authors,imageLinks/thumbnail))"
    )
    parsed_uri = URI.parse(encoded_uri)
    JSON.parse(Net::HTTP.get(parsed_uri))
  end

  def self.set_search_result(result, books)
    result['items'].each do |item|
      uid = item['id']
      title = item['volumeInfo']['title'] ||= ''
      authors = item['volumeInfo']['authors'] ||= []
      image_url = item['volumeInfo']['imageLinks'] ? item['volumeInfo']['imageLinks']['thumbnail'].sub(/http/, 'https') : 'book-default.png'

      book = {
        uid: uid,
        title: title,
        authors: authors.join(', '),
        image_url: image_url
      }
      books << book
    end
    books
  end
end
