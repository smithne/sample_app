class User < ApplicationRecord
    has_secure_password

    before_save { self.email = email.downcase }

    # validations
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    validates :name, presence: true, length: {maximum: 50}
    validates :email, presence: true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

    validates :password, presence: true, length: {minimum: 6}

    # return hash digest of given string
    def User.digest(string)
        cost = cost = ActiveModel::SecurePassword.min_cost ?
            BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
