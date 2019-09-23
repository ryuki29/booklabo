class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update]

  def index
    if user_signed_in?
      redirect_to user_path(current_user)
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @status = params[:status] ? params[:status].to_i : 0
    @books = Book.joins(:user_books).where(user_books: {
      status: @status,
      user_id: params[:id]
    }).order(created_at: "DESC").page(params[:page])

    @following = @user.following.count
    @followers = @user.followers.count
    @current_user_following = @user.follower_ids.include?(current_user.id) ?
                              true : false
  end

  def update
    @user.update(user_params)
    redirect_to user_path(current_user)
  end

  def privacy
  end

  private
  def user_params
    params.require(:user).permit(:name, :image, :url, :description)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
