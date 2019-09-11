class ReviewsController < ApplicationController
  def show
    book = Book.find(params[:id])
    @review = book.review
  end
end
