class AddHCBPaymentAccountToUSPSIndicia < ActiveRecord::Migration[8.0]
  def change
    add_reference :usps_indicia, :hcb_payment_account, null: true, foreign_key: true
    add_column :usps_indicia, :hcb_transfer_id, :string
  end
end
