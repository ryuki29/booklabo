class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
  
  has_many :reviews, dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :books, through: :user_books
  has_many :sns_uids
  has_one_attached :image

  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  def self.find_for_oauth(auth)
    sns_uid = SnsUid.where(uid: auth.uid, provider: auth.provider).first
    
    if sns_uid
      user = sns_uid.user
    else
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
