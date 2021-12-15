class UserPersonality < ApplicationRecord
  belongs_to :user
  has_many :categories, dependent: :restrict_with_exception
  # TODO: after creating transactions check
  #       make sure can delete personality with categories but without transactions
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 14 },
                   uniqueness: { case_sensitive: false, scope: :user_id,
                                 message: 'for personality already exists for this user' }
end
