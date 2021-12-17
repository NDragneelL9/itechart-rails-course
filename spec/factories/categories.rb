FactoryGirl.define do
  factory :category do
    association(:user_personality)
    sequence(:name) { |i| "Food_#{i}" }

    factory :category_with_transactions do
      transient do
        transactions_count 10
      end

      after(:create) do |category, evaluator|
        create_list(:transaction, evaluator.transactions_count, category: category)
      end
    end
  end
end
