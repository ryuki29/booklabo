class BooksController < ApplicationController
  def index
  end

  def create
    @book = Book.new(book_params)
    status = user_books_params[:status].to_i

    user_book = UserBook.new(
      user: current_user, 
      book: @book,
      status: status
    )

    create_review if params[:review].present?

    if @book.save && user_book.save
      render json: {
        "status": "OK",
        "code": 200,
        "user_id": current_user.id, 
        "book_status": status
      }
    else
      render json: {
        "status": "NG",
        "code": 500
      }
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
        item["volumeInfo"]["imageLinks"]["thumbnail"].sub(/http/, 'https') : 
        "book-default.png"

      book = {
        uid: uid,
        title: title,
        authors: authors.join(', '),
        image_url: image_url
      }
      @books << book
    end
  end

  def fetch
    status = params[:status].to_i
    @books = current_user.books.includes(:user_books).order(created_at: 'desc')
    @books = @books.select {|book|
      book.user_books[0].status == status
    }
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

  def review_params
    params.require(:review).permit(:date, :text, :rating)
  end

  def create_review
    require 'Date'
    date = review_params[:date].present? ?
      Date.strptime(review_params[:date], '%Y/%m/%d') :
      nil

    review = Review.new(
      user: current_user, 
      book: @book,
      date: date,
      text: review_params[:text],
      rating: review_params[:rating].to_i
    )

    unless review.save
      render json: {
        "status": "NG",
        "code": 500
      }
    end
  end
end
