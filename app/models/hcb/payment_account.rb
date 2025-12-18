class HCB::PaymentAccount < ApplicationRecord
  belongs_to :user
  belongs_to :oauth_connection, class_name: "HCB::OauthConnection", foreign_key: :hcb_oauth_connection_id

  validates :organization_id, presence: true, uniqueness: { scope: :user_id }
  validates :organization_name, presence: true

  def client
    oauth_connection.client
  end

  def organization
    client.organization!(organization_id)
  end

  def create_disbursement!(amount_cents:, memo:)
    result = client.create_disbursement(
      event_id: organization_id,
      to_organization_id: Rails.application.credentials.dig(:hcb, :recipient_org_id),
      amount_cents: amount_cents,
      name: memo,
    )
    oauth_connection.persist_refreshed_token!
    result
  end
end
