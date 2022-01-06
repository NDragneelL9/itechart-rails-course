FactoryGirl.define do
  factory :note do
    association :tranzaction, factory: :transaction
    description 'Desctiption example'
  end
end
