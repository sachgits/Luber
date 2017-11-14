class User < ApplicationRecord
  before_save {self.email = email.downcase}
  validates :username, presence: true, length: {maximum: 32}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  has_many :cars, dependent: :destroy 
  # If user is deleted, kill his cars too
  # https://stackoverflow.com/questions/29544693/cant-delete-object-due-to-foreign-key-constraint

  has_many :rentals

  # returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
