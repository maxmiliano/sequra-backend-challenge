class AddDisbursementIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :disbursement_id, :integer
  end
end
