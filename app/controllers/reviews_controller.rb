class ReviewsController < ApplicationController
  before_action :find_review_by_book_id, only: [:show, :update]
  before_action :authenticate_user!, except: %i[show]

  def show
  end

  def update
    if @review.update(review_params)
      render json: {
        "user_id": current_user.id
      }
    end
  end

  private
  def review_params
    params.require(:review).permit(:date, :text, :rating)
  end

  def find_review_by_book_id
    book = Book.find(params[:id])
    @review = book.review
  end
end
