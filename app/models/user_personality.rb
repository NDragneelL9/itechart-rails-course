class UserPersonality < ApplicationRecord
  belongs_to :user
  before_destroy :ensure_one_personality_remains
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 14 },
                   uniqueness: { case_sensitive: false, scope: :user_id, 
                                 message: "for personality already exists for this user" }
  
  def ensure_one_personality_remains
    throw(:abort) if  user.user_personalities.count == 1
  end
end
