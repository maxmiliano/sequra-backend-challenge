class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :cif, presence: true
  
end
