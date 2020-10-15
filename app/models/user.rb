class User < ApplicationRecord
  attr_accessor :remember_token

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

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    # ブラウザ１でログアウトして、remember_digestがnilになった場合、
    # ブラウザ２で再度ログアウトしようとするとcookiesが残っているのでエラーになってしまうことを回避する
    return false if remember_digest.nil?
    # remember_tokenは、リスト 9.3のattr_accessor :remember_tokenで定義したアクセサとは異なる
    # remember_digestは、self.remember_digestと同じ
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end
