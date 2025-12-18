class HCB::PaymentAccountsController < ApplicationController
  before_action :require_hcb_connection
  before_action :set_payment_account, only: [:show, :destroy]

  def index
    @payment_accounts = current_user.hcb_payment_accounts
    @available_organizations = available_organizations
  end

  def new
    @organizations = available_organizations
    @payment_account = current_user.hcb_payment_accounts.build
  end

  def create
    org = find_organization(params[:organization_id])
    if org.nil?
      redirect_to new_hcb_payment_account_path, alert: "Organization not found"
      return
    end

    @payment_account = current_user.hcb_payment_accounts.build(
      oauth_connection: current_user.hcb_oauth_connection,
      organization_id: org.id,
      organization_name: org.name,
    )

    if @payment_account.save
      redirect_to hcb_payment_accounts_path, notice: "Payment account created for #{org.name}"
    else
      @organizations = available_organizations
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @payment_account.destroy
    redirect_to hcb_payment_accounts_path, notice: "Payment account removed"
  end

  private

  def require_hcb_connection
    unless current_user.hcb_connected?
      redirect_to new_hcb_oauth_connection_path, alert: "Please link your HCB account first"
    end
  end

  def set_payment_account
    @payment_account = current_user.hcb_payment_accounts.find(params[:id])
  end

  def available_organizations
    current_user.hcb_oauth_connection.organizations
  rescue => e
    Rails.logger.error "Failed to fetch HCB organizations: #{e.message}"
    []
  end

  def find_organization(org_id)
    available_organizations.find { |o| o.id == org_id }
  end
end
