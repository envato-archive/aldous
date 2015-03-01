class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end

