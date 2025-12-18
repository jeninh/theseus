class AddHCBPaymentAccountToBatches < ActiveRecord::Migration[8.0]
  def change
    add_reference :batches, :hcb_payment_account, null: true, foreign_key: true
    add_column :batches, :hcb_transfer_id, :string
  end
end
