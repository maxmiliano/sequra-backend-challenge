FactoryBot.define do
  factory :disbursement do
    amount { 0 }
    year { Time.now.year }
    week { Time.now.strftime("%W").to_i }
    trait :with_orders do
      orders { create_list(:order, 3, :completed) }
    end
  end
end