class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.boolean :withdrawal
      t.monetize :amount, null: false
      t.boolean :important
      t.references :category, foreign_key: true
      t.timestamps null: false
    end
  end
end
