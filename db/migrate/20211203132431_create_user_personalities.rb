class CreateUserPersonalities < ActiveRecord::Migration[5.2]
  def change
    create_table :user_personalities do |t|
      t.string :name, null: false, default: ""
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
  end
end
