class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :shopper
  belongs_to :disbursement, optional: true

  scope :completed, -> { where.not(completed_at: nil) }
  scope :disbursed, -> { where.not(disbursement_id: nil) }
  scope :undisbursed, -> { where(disbursement_id: nil) }
  scope :was_completed_in, -> (year, week) { where(completed_at: Date.commercial(year, week).beginning_of_week..Date.commercial(year, week).end_of_week) }

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
    if amount < TIER_1_LIMIT
      return TIER_1_FEE
    elsif amount < TIER_2_LIMIT
      return TIER_2_FEE
    else
      return TIER_3_FEE
    end
  end

end


