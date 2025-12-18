class HCB::OauthConnection < ApplicationRecord
  belongs_to :user
  has_many :payment_accounts, dependent: :destroy

  has_encrypted :access_token, :refresh_token

  validates :user_id, uniqueness: true

  def client
    @client ||= HCBV4::Client.from_credentials(
      client_id: Rails.application.credentials.dig(:hcb, :client_id),
      client_secret: Rails.application.credentials.dig(:hcb, :client_secret),
      access_token: access_token,
      refresh_token: refresh_token,
      expires_at: expires_at&.to_i,
      base_url: hcb_api_base,
    )
  end

  def organizations
    result = client.organizations
    persist_refreshed_token!
    result
  end

  def persist_refreshed_token!
    token = client.oauth_token
    return unless token.respond_to?(:token)

    if token.token != access_token || token.refresh_token != refresh_token
      update!(
        access_token: token.token,
        refresh_token: token.refresh_token,
        expires_at: token.expires_at ? Time.at(token.expires_at) : nil,
      )
    end
  end

  private

  def hcb_api_base
    Rails.application.credentials.dig(:hcb, :api_base) || "https://hcb.hackclub.com"
  end
end
