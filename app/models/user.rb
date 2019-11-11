class User < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :company

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  alias_method :authenticate, :valid_password?

  def self.from_token_payload(payload)
    self.find payload["sub"]
  end         
end
