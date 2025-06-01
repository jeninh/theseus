# == Schema Information
#
# Table name: public_api_keys
#
#  id               :bigint           not null, primary key
#  name             :string
#  revoked_at       :datetime
#  token_bidx       :string
#  token_ciphertext :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  public_user_id   :bigint           not null
#
# Indexes
#
#  index_public_api_keys_on_public_user_id  (public_user_id)
#  index_public_api_keys_on_token_bidx      (token_bidx) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (public_user_id => public_users.id)
#
require "test_helper"

class Public::APIKeyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
