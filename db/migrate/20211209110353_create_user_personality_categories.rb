class CreateUserPersonalityCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :user_personality_categories do |t|
      t.belongs_to :user_personality
      t.belongs_to :category
      t.timestamps null: false
    end
  end
end
