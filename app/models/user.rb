class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  
  has_many :reviews, dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :books, through: :user_books
  has_one  :sns_uid

  def self.find_for_oauth(auth)
    sns_uid = SnsUid.where(uid: auth.uid, provider: auth.provider).first
    user = User.find(sns_uid.user_id)

    unless sns_uid
      user = User.create(
        email: User.dummy_email(auth),
        name: auth.info.nickname,
        password: Devise.friendly_token[0, 20]
      )

      SnsUid.create(
        uid:      auth.uid,
        provider: auth.provider,
        user: user
      )
    end

    return user
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
