class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter facebook google]
  
  has_many :reviews,    dependent: :destroy
  has_many :user_books, dependent: :destroy
  has_many :books,      through: :user_books,
                        dependent: :destroy
  has_many :sns_uids,   dependent: :destroy
  has_one_attached :image
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true,
                   length: { maximum: 20 }
  VALID_EMAIL_REGIX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: true,
                    format: {
                      with: VALID_EMAIL_REGIX,
                      message: "のフォーマットが不適切です"
                    }
  validates :password, presence: true,
                       length: {
                         minimum: 7,
                         maximum: 128
                       },
                       on: :create
  validates :url, length: { maximum: 100 },
                  format: {
                    with: /\Ahttps?:\/\/[\S]+\z/,
                    message: "のフォーマットが不適切です",
                    allow_nil: true,
                    allow_blank: true
                  }
  validates :description, length: { maximum: 160 }

  def self.find_for_oauth(auth)
    sns_uid = SnsUid.where(uid: auth.uid, provider: auth.provider).first
    
    if sns_uid.present?
      user = sns_uid.user
    elsif auth.provider == "twitter"
      user = User.create_user_with_twitter(auth)
    else
      user = User.where(email: auth.info.email).first
      
      if user.present?
        SnsUid.create(
          uid:      auth.uid,
          provider: auth.provider,
          user: user
        )
      else
        user = User.create_user_with_facebook(auth)
      end
    end

    return user
  end

  private
  def self.create_user_with_twitter(auth)
    user = User.new(
      email: User.dummy_email(auth),
      name: auth.info.nickname,
      password: Devise.friendly_token[0, 20]
    )
    sns_uid = SnsUid.new(
      uid:      auth.uid,
      provider: auth.provider,
      user: user
    )
    
    return user if user.save && sns_uid.save
  end

  def self.create_user_with_facebook(auth)
    user = User.new(
      email: auth.info.email,
      name: auth.info.name,
      password: Devise.friendly_token[0, 20]
    )
    sns_uid = SnsUid.new(
      uid:      auth.uid,
      provider: auth.provider,
      user: user
    )
    return user if user.save && sns_uid.save
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end
