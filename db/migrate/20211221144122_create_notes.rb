class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.text :description, null: false
      t.references :transaction, foreign_key: true
      t.timestamps null: false
    end
  end
end
