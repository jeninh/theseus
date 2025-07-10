class BatchPolicy < ApplicationPolicy
  def index?
    user_can_warehouse
  end

  def show?
    return true if user_is_admin
    user_can_warehouse && record_belongs_to_user
  end

  def new? = user_can_warehouse

  alias_method :create?, :new?

  def edit?
    return true if user_is_admin
    user_can_warehouse && record_belongs_to_user
  end

  alias_method :update?, :edit?

  def destroy?
    return true if user_is_admin
    user_can_warehouse && record_belongs_to_user
  end

  alias_method :map_fields?, :edit?

  alias_method :set_mapping?, :map_fields?

  alias_method :process_batch?, :map_fields?
  alias_method :process_form?, :process_batch?

  alias_method :mark_printed?, :update?

  alias_method :mark_mailed?, :mark_printed?

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

  private

  def record_belongs_to_user = user && record.user == user
end
