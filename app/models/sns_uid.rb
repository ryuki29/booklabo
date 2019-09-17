class SnsUid < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true,
                       inclusion: { in: %w(twitter facebook google) }
  validates :uid, presence: true
end
