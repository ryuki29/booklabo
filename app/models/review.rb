class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validate :validate_review_with_date_after_tommorow
  validates :text, length: { maximum: 255 }
  validates :rating, numericality: {
                       less_than: 6,
                       greater_than_or_equal_to: 0
                     }

  private
  def validate_review_with_date_after_tommorow
    if date.present? && date > Date.today
      errors.add(:date, "は本日以前の日付を選択してください")
    end
  end
end
