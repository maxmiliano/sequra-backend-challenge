class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.belongs_to :merchant, null: false, foreign_key: true
      t.integer :week
      t.integer :year
      t.decimal :amount, null: false, default: 0.0

      t.timestamps
    end
  end
end
