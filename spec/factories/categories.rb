FactoryGirl.define do
  factory :category do
    association(:user_personality)
    sequence(:name) { |i| "Food_#{i}" }

    # TODO: uncomment after creating transactions
    # factory :category_with_transactions do
    #   transient do
    #     categories_count 10
    #   end

    #   after(:create) do |category, evaluator|
    #     create_list(:transaction, evaluator.transactions_count, category: category)
    #   end
    # end
  end
end
