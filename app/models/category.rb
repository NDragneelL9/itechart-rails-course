class Category < ApplicationRecord
  has_many :user_personality_categories
  has_many :user_personalities, through: :user_personality_categories
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 35 },
                   uniqueness: { case_sensitive: false }
  validates :category_type, presence: true, length: { minimum: 3, maximum: 14 }
end