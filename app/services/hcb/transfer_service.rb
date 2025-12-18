class HCB::TransferService
  attr_reader :hcb_payment_account, :amount_cents, :memo, :errors

  def initialize(hcb_payment_account:, amount_cents:, memo:)
    @hcb_payment_account = hcb_payment_account
    @amount_cents = amount_cents
    @memo = memo
    @errors = []
  end

  def call
    return failure("No HCB payment account provided") unless hcb_payment_account
    return failure("Amount must be positive") unless amount_cents.positive?

    transfer = hcb_payment_account.create_disbursement!(
      amount_cents: amount_cents,
      memo: memo,
    )

    transfer
  rescue HCBV4::APIError => e
    failure("HCB disbursement failed: #{e.message}")
  rescue => e
    failure("Transfer failed: #{e.message}")
  end

  private

  def failure(message)
    @errors << message
    false
  end
end
