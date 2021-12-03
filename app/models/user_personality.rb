class UserPersonality < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, 
                   length: { minimum: 3, maximum: 14}, 
                   uniqueness: { case_sensitive: false }
end
