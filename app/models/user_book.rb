class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :status, numericality: {
                       greater_than_or_equal_to: 0,
                       less_than_or_equal_to: 2
                     }
end
