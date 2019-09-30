# frozen_string_literal: true

class CreateUserBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :user_books do |t|
      t.references :user,   foreign_key: true
      t.references :book,   foreign_key: true
      t.integer    :status, null: false, limit: 1
    end
  end
end
