class UsersController < ApplicationController
  def show
    @status = params[:status] ? params[:status].to_i : 0
    @user = User.find(params[:id])
    @books = @user.books.includes(:user_books).order(created_at: 'desc')
    @books = @books.select {|book|
      book.user_books[0].status == @status
    }
  end
end
