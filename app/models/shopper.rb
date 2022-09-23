class Shopper < ApplicationRecord

  has_many :orders, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :nif, presence: true

end
