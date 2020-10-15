class User < ApplicationRecord
  has_many :microposts

  before_save { email.downcase! }

  # https://railstutorial.jp/chapters/modeling_users?version=5.1#table-valid_email_regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },  format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: {case_sensitive: false}
  # uniqueness: true -> 大文字小文字を区別
  # uniqueness: {case_sensitive: false} -> 大文字小文字の区別を無視

  has_secure_password # railsの組み込みメソッド
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
