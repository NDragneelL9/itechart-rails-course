class CreateCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: ''
      t.monetize :amount, default: 0.00
      t.references :user_personality, foreign_key: true
      t.timestamps null: false
    end

    add_index :categories, %i[user_personality_id name], unique: true
  end
end
