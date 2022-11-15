require 'rails_helper'

RSpec.describe Order, type: :model do

  it { is_expected.to belong_to(:merchant) }
  it { is_expected.to belong_to(:shopper) }

  it { is_expected.to validate_presence_of(:merchant) }
  it { is_expected.to validate_presence_of(:shopper) }

  describe 'scopes' do

    let!(:complete_order) { create(:order, :completed) }
    let!(:incomplete_order) { create(:order, :incomplete) }
    let!(:disbursed_order) { create(:order, :disbursed) }
    let!(:undisbursed_order) { create(:order, :undisbursed) }

    it 'should return completed orders' do
      expect(Order.completed).to include(complete_order)
    end

    it 'should return disbursed orders' do
      expect(Order.disbursed).to include(disbursed_order)
    end

    it 'should return undisbursed orders' do
      expect(Order.undisbursed).to include(undisbursed_order)
    end

    it 'should return orders by year and week' do
      expect(Order.was_completed_in(complete_order.completed_at.year, complete_order.completed_at.strftime("%W").to_i)).to include(complete_order)
    end

  end  

end
