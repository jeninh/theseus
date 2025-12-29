class API::RevocationsController < ActionController::API
  def create
    a = request.headers["authorization"]
    return head 401 unless a.present? && ActiveSupport::SecurityUtils.secure_compare(a, Rails.application.credentials.revoker_key)
    t = params[:token]
    return head 400 unless t.present?

    public_api_key = Public::APIKey.accessible.find_by(token: t)

    if public_api_key.present?
      public_api_key.revoke!
      user = public_api_key.public_user
      return render json: {
        success: true,
        owner_email: user.email,
        key_name: public_api_key.name
      }
    end

    internal_api_key = APIKey.accessible.find_by(token: t)

    if internal_api_key.present?
      internal_api_key.revoke!
      user = internal_api_key.user
      return render json: {
        success: true,
        owner_email: user.email,
        key_name: internal_api_key.pretty_name
      }
    end

    render json: {
      success: false
    }
  end
end
