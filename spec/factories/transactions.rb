FactoryGirl.define do
  factory :transaction do
    association(:category)
    withdrawal true
    amount_cents 100
  end
end
