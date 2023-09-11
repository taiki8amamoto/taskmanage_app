class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, 
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, length: { minimum: 6 }
  enum role: { admin: 0, general: 5}

  before_destroy :must_not_destroy_last_one_admin

  private

  def must_not_destroy_last_one_admin
    if User.where(role: 0).count <= 1 && self.role == "admin"
      throw :abort
    end
  end

end
