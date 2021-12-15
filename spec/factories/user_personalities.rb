FactoryGirl.define do
  factory :user_personality do
    association(:user)
    sequence(:name) { |i| "Son_#{i}" }

    factory :user_personality_with_categories do
      transient do
        categories_count 10
      end

      after(:create) do |user_personality, evaluator|
        create_list(:category, evaluator.categories_count, user_personality: user_personality)
      end
    end
  end
end
