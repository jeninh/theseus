class Warehouse::BatchPolicy < ApplicationPolicy
  def index? = user_can_warehouse

  def show? = user_can_warehouse

  def new? = user_can_warehouse

  alias_method :create?, :new?

  def edit? = user_can_warehouse

  alias_method :update?, :edit?

  def destroy? = user_is_admin

  def map_fields? = user_can_warehouse

  alias_method :set_mapping?, :map_fields?
  alias_method :process_form?, :map_fields?
  alias_method :process_batch?, :map_fields?

  alias_method :mark_printed?, :update?
  alias_method :mark_mailed?, :update?

  alias_method :update_costs?, :show?

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user_can_warehouse
        scope.where(user: user)
      else
        scope.none
      end
    end

    private

    def user_can_warehouse
      user&.can_warehouse? || user&.admin?
    end
  end
end
