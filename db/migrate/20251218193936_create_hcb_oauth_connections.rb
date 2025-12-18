class CreateHCBOauthConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :hcb_oauth_connections do |t|
      t.references :user, null: false, foreign_key: true
      t.text :access_token_ciphertext
      t.text :refresh_token_ciphertext
      t.datetime :expires_at

      t.timestamps
    end
  end
end
