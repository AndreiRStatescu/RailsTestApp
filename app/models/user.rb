class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :accounts

  validates :first_name, :last_name, presence: true, on: :update

  def full_name
    return email if first_name.blank? || last_name.blank?
    "#{first_name} #{last_name}"
  end
end
