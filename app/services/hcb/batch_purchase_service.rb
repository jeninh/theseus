class HCB::BatchPurchaseService
  class DisbursementError < StandardError; end

  attr_reader :batch, :hcb_payment_account, :usps_payment_account, :errors

  def initialize(batch:, hcb_payment_account:, usps_payment_account:)
    @batch = batch
    @hcb_payment_account = hcb_payment_account
    @usps_payment_account = usps_payment_account
    @errors = []
  end

  def call
    return failure("No HCB payment account provided") unless hcb_payment_account
    return failure("No USPS payment account provided") unless usps_payment_account

    letters_needing_indicia = batch.letters.select do |letter|
      letter.postage_type == "indicia" && letter.usps_indicium.nil?
    end

    return true if letters_needing_indicia.empty?

    total_cost_cents = estimate_total_cost_cents(letters_needing_indicia)

    ActiveRecord::Base.transaction do
      transfer = create_disbursement!(total_cost_cents)
      batch.update!(
        hcb_payment_account: hcb_payment_account,
        hcb_transfer_id: transfer.id,
      )

      purchase_indicia_for_letters!(letters_needing_indicia)
    end

    true
  rescue HCBV4::APIError => e
    failure("HCB disbursement failed: #{e.message}")
  rescue => e
    failure("Batch purchase failed: #{e.message}")
  end

  private

  def create_disbursement!(amount_cents)
    hcb_payment_account.create_disbursement!(
      amount_cents: amount_cents,
      memo: "Theseus batch postage: #{batch.letters.count} letters",
    )
  end

  def purchase_indicia_for_letters!(letters)
    payment_token = usps_payment_account.create_payment_token

    letters.each do |letter|
      indicium = USPS::Indicium.create!(
        letter: letter,
        payment_account: usps_payment_account,
        hcb_payment_account: hcb_payment_account,
        mailing_date: batch.letter_mailing_date,
      )
      indicium.buy!(payment_token)
    end
  end

  def estimate_total_cost_cents(letters)
    letters.sum do |letter|
      if letter.processing_category == "flat"
        150
      else
        73
      end
    end
  end

  def failure(message)
    @errors << message
    false
  end
end
