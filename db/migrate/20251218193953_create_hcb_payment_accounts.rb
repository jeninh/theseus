class CreateHCBPaymentAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :hcb_payment_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hcb_oauth_connection, null: false, foreign_key: true
      t.string :organization_id
      t.string :organization_name

      t.timestamps
    end
  end
end
