class ChangeIndexesForUserPersonalities < ActiveRecord::Migration[5.2]
  def change
    remove_index :user_personalities, :name
    add_index :user_personalities, %i[user_id name], unique: true
  end
end
