class UserPersonalityCategory < ApplicationRecord
  belongs_to :user_personality
  belongs_to :category
end