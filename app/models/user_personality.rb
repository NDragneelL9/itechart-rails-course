class UserPersonality < ApplicationRecord
  belongs_to :user
  before_destroy :ensure_one_personality_remains
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 14 },
                   uniqueness: { case_sensitive: false, scope: :user_id,
                                 message: 'for personality already exists for this user' }

  private 

  def ensure_one_personality_remains
    raise ActiveRecord::Rollback if user.user_personalities.count == 1
  end
end
