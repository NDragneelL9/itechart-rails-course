class Category < ApplicationRecord
  belongs_to :user_personality
  
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 14 },
                   uniqueness: { case_sensitive: false, scope: :user_personality_id,
                                 message: 'for category already exists for this personality' }

end
