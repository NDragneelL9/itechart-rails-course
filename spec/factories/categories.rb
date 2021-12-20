FactoryGirl.define do
  factory :category do
    association(:user_personality)
    sequence(:name) { |i| "Food_#{i}" }

    factory :category_with_transactions do
      before(:create) do |category|
        category.transactions << build(:transaction)
      end
    end
  end
end
