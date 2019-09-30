# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index search fetch]

  def index; end

  def create
    @book = Book.new(book_params)
    status = user_books_params[:status].to_i

    user_book = UserBook.new(
      user: current_user,
      book: @book,
      status: status
    )

    create_review if params[:review].present?
    return unless @book.save && user_book.save

    render json: { "user_id": current_user.id, "book_status": status }
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
  end

  def search
    @books = []
    @total_items = 0
    @keyword = params[:keyword]
    @page = params[:page]

    return if params[:keyword].empty?

    result = Book.search_books(@keyword, @page)

    @total_items = result['totalItems']

    return if @total_items.zero?

    @total_items = 100 if @total_items > 100
    @books = Book.set_search_result(result, @books)
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
    date = review_params[:date].present? ? Date.strptime(review_params[:date], '%Y/%m/%d') : nil

    review = Review.new(
      user: current_user,
      book: @book,
      date: date,
      text: review_params[:text],
      rating: review_params[:rating].to_i
    )

    create_tweet(review.text) if review.save && review_params[:tweet] == 'true'
  end

  def create_tweet(review)
    client = SnsUid.create_twitter_client(
      session[:oauth_token],
      session[:oauth_token_secret]
    )
    text = "#{@book.authors}の#{@book.title}を読了\n感想：#{review}"
    text = "#{text[0..136]}..." if text.length > 140
    client.update(text)
  end
end
