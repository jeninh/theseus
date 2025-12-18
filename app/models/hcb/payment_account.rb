# == Schema Information
#
# Table name: hcb_payment_accounts
#
#  id                      :bigint           not null, primary key
#  organization_name       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  hcb_oauth_connection_id :bigint           not null
#  organization_id         :string
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_hcb_payment_accounts_on_hcb_oauth_connection_id  (hcb_oauth_connection_id)
#  index_hcb_payment_accounts_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hcb_oauth_connection_id => hcb_oauth_connections.id)
#  fk_rails_...  (user_id => users.id)
#
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
      to_organization_id: ENV.fetch("HCB_RECIPIENT_ORG_ID"),
      amount_cents: amount_cents,
      name: memo,
    )
    oauth_connection.persist_refreshed_token!
    result
  end
end
