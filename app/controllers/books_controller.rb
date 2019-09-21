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
        "user_id": current_user.id, 
        "book_status": status
      }
    end
  end

  def destroy
    book = Book.find(params[:id]);
    book.destroy
  end

  def search
    @total_items = 0
    @keyword = params[:keyword]
    @page = params[:page]

    return unless params[:keyword].present?

    result = Book.search_books(@keyword, @page)
    @total_items = Book.set_total_items(result["totalItems"])

    @total_items = result["totalItems"]
    if @total_items == 0
      return
    elsif @total_items > 100
      @total_items = 100
    end

    @books = Book.set_search_result(result)
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
