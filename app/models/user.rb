class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist


  #Relations
  has_many :pets, class_name: :Pet, foreign_key: 'owner_id'
  has_many :dogs, -> { where(type: 'Dog') }, class_name: 'Pet'
  has_many :cats, -> { where(type: 'Cat') }, class_name: 'Pet'
end
