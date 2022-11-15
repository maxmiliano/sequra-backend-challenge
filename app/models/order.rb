class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :shopper
  belongs_to :disbursement, optional: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :disbursed, -> { where.not(disbursement_id: nil) }
  scope :undisbursed, -> { where(disbursement_id: nil) }
  scope :was_completed_in, -> (year, week) { where(completed_at: Date.commercial(year, week).beginning_of_week.beginning_of_day..Date.commercial(year, week).end_of_week.end_of_day) }

  validates :merchant, presence: true
  validates :shopper, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  TIER_1_LIMIT = 50
  TIER_2_LIMIT = 300

  TIER_1_FEE = 0.01
  TIER_2_FEE = 0.0095
  TIER_3_FEE = 0.0085

  def net_amount
    amount - fee_amount
  end

  def fee_amount
    amount * fee
  end

  def fee

    merchant
      .merchant_fees
      .select{|mf| !mf.tier_limit.nil?}
      .sort_by(&:tier_limit).each do |tier|
      return tier.tier_fee if amount < tier.tier_limit
    end

    return merchant.merchant_fees.where(tier_limit: nil).tier_fee
  end

end


