require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  
    it { is_expected.to validate_presence_of(:merchant) }
    it { is_expected.to validate_presence_of(:week) }
    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:amount) }
  
    it { is_expected.to validate_numericality_of(:week).only_integer }
    it { is_expected.to validate_numericality_of(:year).only_integer }
    it { is_expected.to validate_numericality_of(:amount) }
  
    describe 'class methods' do

      let(:time_now) { Time.now }
      let(:merchant) { create(:merchant) }
      let(:shopper) { create(:shopper)}
      let!(:order) do
        create(
          :order,
          :undisbursed,
          merchant: merchant,
          shopper: shopper,
          completed_at: time_now,
          amount: 100.00)

      end

      describe '#process_disbursements' do
        it 'should create disbursement and associate it to order' do
          expect do 

            expect(order.disbursement).to be_nil
            described_class.process_disbursements(time_now.year, time_now.strftime("%W").to_i)
            order.reload
            expect(order.disbursement).not_to be_nil
            expect(order.disbursement.orders.first).to eq(order)
          end.to change { described_class.count }.by(1) 

        end
  
        context 'with more than one order' do
          let!(:order2) do
            create(
              :order,
              :undisbursed,
              merchant: merchant,
              shopper: shopper,
              completed_at: time_now,
              amount: 40.00)
          end

          let!(:order3) do
            create(
              :order,
              :undisbursed,
              merchant: merchant,
              shopper: shopper,
              completed_at: time_now,
              amount: 60.00)
          end

          it 'should calculate right amounts for disbursement' do
          
            described_class.process_disbursements(time_now.year, time_now.strftime("%W").to_i)
            exptected_ammount = order.net_amount + order2.net_amount + order3.net_amount
            expect(described_class.first.amount).to eq BigDecimal(exptected_ammount)
          end          
        end
      end
    end
end
