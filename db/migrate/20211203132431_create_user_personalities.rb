# creating user_personalities with reference to users
class CreateUserPersonalities < ActiveRecord::Migration[5.2]
  def change
    create_table :user_personalities do |t|
      t.string :name, null: false, default: ''
      t.references :user, foreign_key: true

      t.timestamps null: false
    end

    add_index :user_personalities, :name, unique: true
  end
end
