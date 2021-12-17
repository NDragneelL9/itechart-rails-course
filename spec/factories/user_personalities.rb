FactoryGirl.define do
  factory :user_personality do
    association(:user)
    sequence(:name) { |i| "Son_#{i}" }

    factory :user_personality_with_categories do
      transient do
        categories_count 2
      end

      after(:create) do |user_personality, evaluator|
        create_list(:category, evaluator.categories_count, user_personality: user_personality)
      end
    end

    factory :user_personality_with_categories_transactions do
      before(:create) do |user_personality|
        user_personality.categories << build(:category)
        user_personality.categories.last.transactions << build(:transaction)
      end
    end
  end
end
