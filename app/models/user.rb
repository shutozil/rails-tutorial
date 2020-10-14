class User < ApplicationRecord
  # https://railstutorial.jp/chapters/modeling_users?version=5.1#table-valid_email_regex
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :microposts
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },  format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: {case_sensitive: false}
  
  # uniqueness: true -> 大文字小文字を区別
  # uniqueness: {case_sensitive: false} -> 大文字小文字の区別を無視
  before_save { email.downcase! }

end
