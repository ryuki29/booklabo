class UsersController < ApplicationController
  before_action :find_user, only: [:show, :update]

  def show
    @status = params[:status] ? params[:status].to_i : 0
    @books = Book.joins(:user_books).where(user_books: {
      status: @status,
      user_id: params[:id]
    }).order(created_at: "DESC").page(params[:page])

    @following = @user.following_ids.length
    @followers = Relationship.where(followed_id: @user.id).count
    @current_user_following = current_user&.following_ids&.include?(@user.id) ? true : false
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
