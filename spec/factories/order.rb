FactoryBot.define do
  factory :order do
    amount { 100 }
    merchant { create(:merchant) }
    shopper { create(:shopper) }

    trait :completed do
        completed_at { Time.now }
    end

    trait :incomplete do
        completed_at { nil }
    end

    trait :disbursed do
      completed_at { Time.now }
      merchant { create(:merchant) }
      shopper { create(:shopper) }
      disbursement do 
        create(
          :disbursement,
          merchant: merchant,
          year: self.completed_at.year,
          week: self.completed_at.strftime("%W").to_i,
        ) 
      end
    end

    trait :undisbursed do
      disbursement { nil }
    end
  end
end