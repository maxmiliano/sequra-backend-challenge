class CreateMerchantFees < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_fees do |t|
      t.decimal :tier_limit
      t.decimal :tier_fee
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
