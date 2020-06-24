class User < ActiveRecord::Base
    has_many :posts
    has_many :replies
    
    has_secure_password
    validates :username, presence: true
    validates :username, uniqueness: true
end