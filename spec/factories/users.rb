FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "test#{i}@test.com" }
    password 'password'
  end
end
