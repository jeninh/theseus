class HCB::OauthConnection < ApplicationRecord
  belongs_to :user
  has_many :payment_accounts, dependent: :destroy

  has_encrypted :access_token, :refresh_token

  validates :user_id, uniqueness: true

  def client
    @client ||= HCBV4::Client.new(
      client_id: Rails.application.credentials.dig(:hcb, :client_id),
      client_secret: Rails.application.credentials.dig(:hcb, :client_secret),
      access_token: access_token,
      refresh_token: refresh_token,
      expires_at: expires_at&.to_i,
      on_token_refresh: ->(new_access, new_refresh, new_expires) {
        update!(
          access_token: new_access,
          refresh_token: new_refresh,
          expires_at: Time.at(new_expires),
        )
      },
    )
  end

  def organizations
    client.user.organizations
  end
end
