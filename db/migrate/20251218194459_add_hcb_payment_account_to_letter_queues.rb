class AddHCBPaymentAccountToLetterQueues < ActiveRecord::Migration[8.0]
  def change
    add_reference :letter_queues, :hcb_payment_account, null: true, foreign_key: true
  end
end
