class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index search fetch]

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

  def destroy
    book = Book.find(params[:id]);
    book.destroy
    render json: { 
      "status": "OK",
      "code": 200
    }
  end

  def search
    require 'net/http'
    require 'uri'
    require 'json'

    @books = []
    @keyword = params[:keyword]
    @total_items = 0
    @page = params[:page]

    return unless params[:keyword].present?

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
    params.require(:review).permit(:date, :text, :rating, :tweet)
  end

  def create_review
    require 'date'
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

    if review.save && review_params[:tweet] == "true"
      create_tweet(review.text)
    end
  end

  def create_tweet(review)
    client = twitter_client
    text = "#{@book.authors}の#{@book.title}を読了\n感想：#{review}"
    if text.length > 140
      text = "#{text[0..136]}..." 
    end
    client.update(text)
  end

  def twitter_client
    client = Twitter::REST::Client.new do |config|
      config.access_token = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
      config.consumer_key = Rails.application.credentials.twitter[:twitter_api_key]
      config.consumer_secret = Rails.application.credentials.twitter[:twitter_api_secret]
    end

    return client
  end
end
