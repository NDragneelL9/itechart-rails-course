class UpdateForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :user_personalities, :users
    add_foreign_key :user_personalities, :users, on_delete: :cascade
  end
end
