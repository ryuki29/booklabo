class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update]

  def show
    @status = params[:status] ? params[:status].to_i : 0
    @books = @user.books.includes(:user_books).order(created_at: 'desc')
    @books = @books.select {|book|
      book.user_books[0].status == @status
    }
  end

  def update
    @user.update(user_params)
    
    if @user.save
      redirect_to user_path(current_user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :image, :url, :description)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
