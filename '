class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy

  has_many :merchant_fees, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :cif, presence: true

 def fee(amount)

    merchant_fees
      .select{|mf| !mf.tier_limit.nil?}
      .sort_by(&:tier_limit).each do |tier|
      return tier.tier_fee if amount < tier.tier_limit
    end

    return merchant.merchant_fees.where(tier_limit: nil).tier_fee
  end

  def net_amount(amount)
    return amount - fee_amount(amount)
  end

  def fee_amount(amount)
    return amount * fee(amount)
  end

end
