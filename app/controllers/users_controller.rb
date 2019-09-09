class UsersController < ApplicationController
  def show
    @books = []
    user_books = current_user.user_books.where(status: 0)

    if user_books.length > 0
      user_books.each do |user_book|
        @books << user_book.book
      end
    end
  end
end
