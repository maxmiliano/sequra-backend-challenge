class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders, dependent: :destroy

  validates :merchant, presence: true
  validates :week, presence: true, numericality: { only_integer: true }
  validates :year, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: true

  scope :by_year_and_week, -> (year, week) { where(year: year, week: week) }

  class << self
    
    def process_disbursements(year = Time.current.year, week = Time.current.commercial)
      create_disbrusements_from_orders(year, week)
      calculate_amounts_for_week(year, week)
    end

    private

    def create_disbrusements_from_orders(year = Time.current.year, week = Time.current.commercial)
      Order.undisbursed.was_completed_in(year, week).each do |order|
        disbursement = Disbursement.find_or_create_by(merchant: order.merchant, year: year, week: week)
        order.update(disbursement: disbursement)
      end
    end

    def calculate_amounts_for_week(year = Time.current.year, week = Time.current.commercial)
      Disbursement.where(year: year, week: week).each do |disbursement|
        disbursement_sum = disbursement.orders.inject(0.0) { |sum, order| sum + order.net_amount }
        disbursement.update(amount: disbursement_sum)
      end
    end

  end

end
