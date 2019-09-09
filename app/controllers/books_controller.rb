class BooksController < ApplicationController
  def index
  end

  def create
    @book = Book.new(book_params)
    user_book = UserBook.new(
      user: current_user, 
      book: @book,
      status: user_books_params[:status].to_i
    )

    if @book.save && user_book.save
      render json: { "status": 'ok', "code": 200  }
    else
      render json: { "status": "ng", "code": 500 }
    end
  end

  def search
    require 'net/http'
    require 'uri'
    require 'json'

    @books = []
    @keyword = params[:keyword]
    @total_items = 0
    @page = params[:page]

    return if params[:keyword].empty?

    encoded_uri = URI.encode(
      "https://www.googleapis.com/books/v1/volumes?maxResults=20&startIndex=#{params[:page]}&q=#{params[:keyword]}&fields=totalItems,items(id,volumeInfo(title,authors,imageLinks/thumbnail))"
    )
    parsed_uri = URI.parse(encoded_uri)
    result = JSON.parse(Net::HTTP.get(parsed_uri))

    @total_items = result["totalItems"]
    return if @total_items == 0
    @total_items = 100 if @total_items > 0
    
    result["items"].each do |item|
      uid = item["id"]
      title = item["volumeInfo"]["title"] ||= ""
      authors = item["volumeInfo"]["authors"] ||= []
      image_url = item["volumeInfo"]["imageLinks"] ? 
        item["volumeInfo"]["imageLinks"]["thumbnail"] : 
        "book-default.png"

      book = {
        uid: uid,
        title: title,
        authors: authors,
        image_url: image_url
      }
      @books << book
    end
  end

  def fetch
    @books = []
    user_books = current_user.user_books.where(status: params[:status])
    if user_books.length > 0
      user_books.each do |user_book|
        @books << user_book.book
      end
    end
  end

  private
  def book_params
    params.require(:book).permit(
      :title,
      :authors,
      :image_url,
      :uid
    )
  end

  def user_books_params
    params.require(:user_book).permit(:status)
  end
end
