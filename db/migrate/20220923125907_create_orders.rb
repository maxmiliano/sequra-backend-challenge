class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :merchant, null: false, foreign_key: true, index: true
      t.belongs_to :shopper, null: false, foreign_key: true, index: true
      t.decimal :amount, null: false
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
