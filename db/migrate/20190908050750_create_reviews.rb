# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.date       :date
      t.string     :text
      t.integer    :rating, limit: 1
      t.references :user,   foreign_key: true
      t.references :book,   foreign_key: true
      t.timestamps
    end
  end
end
