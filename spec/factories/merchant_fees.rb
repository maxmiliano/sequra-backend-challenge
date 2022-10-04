FactoryBot.define do
  factory :merchant_fee do
    tier_limit { "9.99" }
    tier_fee { "9.99" }
    merchant { nil }
  end
end
