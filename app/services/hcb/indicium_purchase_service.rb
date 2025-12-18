class HCB::IndiciumPurchaseService
  class DisbursementError < StandardError; end

  attr_reader :indicium, :hcb_payment_account, :errors

  def initialize(indicium:, hcb_payment_account:)
    @indicium = indicium
    @hcb_payment_account = hcb_payment_account
    @errors = []
  end

  def call
    return failure("No HCB payment account provided") unless hcb_payment_account
    return failure("No letter attached to indicium") unless indicium.letter

    estimated_cost_cents = estimate_cost_cents

    ActiveRecord::Base.transaction do
      transfer = create_disbursement!(estimated_cost_cents)
      indicium.hcb_payment_account = hcb_payment_account
      indicium.hcb_transfer_id = transfer.id
      indicium.save!

      indicium.buy!
    end

    true
  rescue HCBV4::APIError => e
    failure("HCB disbursement failed: #{e.message}")
  rescue => e
    failure("Purchase failed: #{e.message}")
  end

  private

  def create_disbursement!(amount_cents)
    hcb_payment_account.create_disbursement!(
      amount_cents: amount_cents,
      memo: disbursement_memo,
    )
  end

  def estimate_cost_cents
    letter = indicium.letter
    base_cents = if letter.processing_category == "flat"
      150
    else
      73
    end
    (base_cents * 1.0).ceil
  end

  def disbursement_memo
    "Theseus postage: #{indicium.letter.public_id}"
  end

  def failure(message)
    @errors << message
    false
  end
end
