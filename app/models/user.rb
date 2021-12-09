class User < ApplicationRecord
  has_many :user_personalities, dependent: :destroy
  after_create :create_default_personality

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def create_default_personality
    @personality = UserPersonality.new(name: 'Myself', user_id: id)
    @personality.save
  end
end
