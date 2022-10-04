class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders, dependent: :destroy

  validates :merchant, presence: true
  validates :week, presence: true, numericality: { only_integer: true }
  validates :year, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: true

  scope :by_year_and_week, -> (year, week) { where(year: year, week: week) }

  class << self
    
    # This method is called to process disbursements for a given year and week
    # It will create a disbursement for each merchant that has orders for the given year and week
    # params:
    #  year: Integer (default: Time.now.year)
    #  week: Integer (default: Time.now.strftime("%W").to_i, which is the current week number)
    def process_disbursements(year = Time.current.year, week = Time.current.strftime("%W").to_i)
      create_disbrusements_from_orders(year, week)
      calculate_amounts_for_week(year, week)
    end

    private

    # This method will create a disbursement for each merchant that has orders for the given year and week
    def create_disbrusements_from_orders(year = Time.current.year, week = Time.current.strftime("%W").to_i)
      Order.undisbursed.was_completed_in(year, week).each do |order|
        disbursement = Disbursement.find_or_create_by(merchant: order.merchant, year: year, week: week)
        order.update(disbursement: disbursement)
      end
    end

    # This method will calculate the amount for each disbursement
    def calculate_amounts_for_week(year = Time.current.year, week = Time.current.strftime("%W").to_i)
      Disbursement.where(year: year, week: week).includes(:orders).each do |disbursement|
        disbursement_sum = disbursement.orders.inject(0.0) { |sum, order| sum + disbursement.merchant.net_amount(order.amount) }
        disbursement.update(amount: disbursement_sum)
      end
    end

  end

end
